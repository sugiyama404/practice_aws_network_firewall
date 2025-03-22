data "archive_file" "lambda_func1" {
  type        = "zip"
  source_dir  = "./modules/lambda/src/func1/in"
  output_path = "./modules/lambda/src/func1/out/lambda_function_payload.zip"
}

data "archive_file" "lambda_func2" {
  type        = "zip"
  source_dir  = "./modules/lambda/src/func2/in"
  output_path = "./modules/lambda/src/func2/out/lambda_function_payload.zip"
}
