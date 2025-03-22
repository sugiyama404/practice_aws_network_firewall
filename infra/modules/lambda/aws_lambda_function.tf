resource "aws_lambda_function" "main" {
  filename         = data.archive_file.lambda_func1.output_path
  function_name    = "ConnectToGoogle"
  description      = "lambda_function"
  role             = var.iam_role_lambda
  architectures    = ["x86_64"]
  handler          = "index.lambda_handler"
  source_code_hash = data.archive_file.lambda_func1.output_base64sha256
  timeout          = 30
  runtime          = "python3.12"
  depends_on       = [aws_cloudwatch_log_group.lambda]

  vpc_config {
    subnet_ids         = [var.subnet_private_subnet_1a_id]
    security_group_ids = [var.lambda_sg_id]
  }

  tags = {
    Name = "${var.app_name}-main-lambda"
  }
}

resource "aws_lambda_function" "sub" {
  filename         = data.archive_file.lambda_func2.output_path
  function_name    = "ConnectToChatGPT"
  description      = "lambda_function"
  role             = var.iam_role_lambda
  architectures    = ["x86_64"]
  handler          = "index.lambda_handler"
  source_code_hash = data.archive_file.lambda_func2.output_base64sha256
  timeout          = 30
  runtime          = "python3.12"
  depends_on       = [aws_cloudwatch_log_group.lambda]

  vpc_config {
    subnet_ids         = [var.subnet_private_subnet_1a_id]
    security_group_ids = [var.lambda_sg_id]
  }

  tags = {
    Name = "${var.app_name}-sub-lambda"
  }
}
