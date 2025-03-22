resource "aws_vpc_endpoint" "logs" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.ap-northeast-1.logs"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = [aws_subnet.private_subnet_1a.id]
  security_group_ids  = [aws_security_group.vpc_endpoint_sg.id]

  tags = {
    "Name" = "logs-endpoint"
  }
}
