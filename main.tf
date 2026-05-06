provider "aws" {
  region = "ap-south-2"
}

resource "aws_key_pair" "deployer" {
  key_name   = "terraform-key"
  public_key = file("~/.ssh/terraform-key.pub")
}

# VPC
module "vpc" {
  source   = "./modules/vpc"
  vpc_cidr = "10.0.0.0/16"
  name     = "main-vpc"
}

# Subnets
module "public_subnet" {
  source = "./modules/subnet"

  vpc_id = module.vpc.vpc_id
  cidr   = "10.0.1.0/24"
  public = true
  name   = "public"
}

module "private_subnet" {
  source = "./modules/subnet"

  vpc_id = module.vpc.vpc_id
  cidr   = "10.0.2.0/24"
  public = false
  name   = "private"
}

# IGW
module "igw" {
  source = "./modules/igw"
  vpc_id = module.vpc.vpc_id
}

# NAT
module "nat" {
  source = "./modules/nat"
  public_subnet_id = module.public_subnet.subnet_id
}

# Route Tables
module "public_rt" {
  source = "./modules/route_table"

  vpc_id     = module.vpc.vpc_id
  subnet_id  = module.public_subnet.subnet_id
  gateway_id = module.igw.igw_id
}

module "private_rt" {
  source = "./modules/route_table"

  vpc_id         = module.vpc.vpc_id
  subnet_id      = module.private_subnet.subnet_id
  nat_gateway_id = module.nat.nat_id
}

# Security Groups
module "security_group" {
  source = "./modules/security_group"
  vpc_id = module.vpc.vpc_id
}

# EC2 Public (Bastion)
module "ec2_public" {
  source = "./modules/ec2"

  subnet_id = module.public_subnet.subnet_id
  public_ip = true
  name      = "bastion"

  key_name = aws_key_pair.deployer.key_name
  sg_ids   = [module.security_group.bastion_sg_id]
}

# EC2 Private
module "ec2_private" {
  source = "./modules/ec2"

  subnet_id = module.private_subnet.subnet_id
  public_ip = false
  name      = "private-server"

  key_name = aws_key_pair.deployer.key_name
  sg_ids   = [module.security_group.private_sg_id]
}
