data "archive_file" "lambda" {
  type        = "zip"
  source_dir  = "./modules/lambda/src/in"
  output_path = "./modules/lambda/src/out/lambda_function_payload.zip"
}

resource "aws_lambda_function" "main" {
  filename         = "./modules/lambda/src/out/lambda_function_payload.zip"
  function_name    = "lambda_function"
  description      = "lambda_function"
  role             = var.iam_role_lambda
  architectures    = ["x86_64"]
  handler          = "index.lambda_handler"
  source_code_hash = data.archive_file.lambda.output_base64sha256
  timeout          = 30
  runtime          = "python3.12"
  depends_on       = [aws_cloudwatch_log_group.lambda]

  vpc_config {
    subnet_ids         = [var.subnet_private_subnet_1a_id]
    security_group_ids = [var.lambda_sg_id]
  }

  tags = {
    Name = "${var.app_name}-lambda"
  }
}
