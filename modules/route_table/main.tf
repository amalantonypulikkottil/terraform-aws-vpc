resource "aws_route_table" "this" {
  vpc_id = var.vpc_id
}

# Single route resource (handles both IGW and NAT)
resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.this.id
  destination_cidr_block = "0.0.0.0/0"

  # Only one will be used, the other must be null
  gateway_id     = var.gateway_id
  nat_gateway_id = var.nat_gateway_id
}

# Associate subnet
resource "aws_route_table_association" "assoc" {
  subnet_id      = var.subnet_id
  route_table_id = aws_route_table.this.id
}
