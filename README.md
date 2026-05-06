# Terraform AWS VPC Module

## Description
This module creates:
- VPC
- Public & Private Subnets
- NAT Gateway
- Route Tables
- Bastion Host
- Private EC2

## Usage

```hcl
module "vpc" {
  source = "your-username/vpc/aws"

  vpc_cidr = "10.0.0.0/16"
}
