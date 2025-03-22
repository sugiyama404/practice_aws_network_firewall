output "main_vpc_id" {
  value = aws_vpc.main.id
}
output "subnet_public_subnet_1a_id" {
  value = aws_subnet.public_subnet_1a.id
}

output "subnet_private_subnet_1a_id" {
  value = aws_subnet.private_subnet_1a.id
}

output "lambda_sg_id" {
  value = aws_security_group.lambda_sg.id
}
