output "iam_role_lambda" {
  value = aws_iam_role.lambda_role.arn
}

output "iam_role_kendra" {
  value = aws_iam_role.kendra_role.arn
}

output "iam_role_ecs" {
  value = aws_iam_role.ecs_role.arn
}
