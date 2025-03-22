# SecurityGroup for vpc_endpoint
resource "aws_security_group" "lambda_sg" {
  name   = "lambda-sg"
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.app_name}-lambda-sg"
  }
}

# SecurityGroup for vpc_endpoint
resource "aws_security_group" "vpc_endpoint_sg" {
  name   = "vpc-endpoint-sg"
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.app_name}-vpc-endpoint-sg"
  }
}
