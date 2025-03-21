resource "aws_cloudwatch_log_group" "lambda" {
  name = "/aws/lambda/${var.app_name}"
}
