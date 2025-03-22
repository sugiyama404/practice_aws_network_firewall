# Elastic IP
resource "aws_eip" "nat_eip" {
  tags = {
    Name = "nat-eip"
  }
}

# NAT Gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.nat_gateway_subnet.id
  tags = {
    Name = "nat-gateway"
  }
}

