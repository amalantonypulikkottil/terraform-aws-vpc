resource "aws_subnet" "this" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.cidr
  map_public_ip_on_launch = var.public

  tags = {
    Name = var.name
  }
}
