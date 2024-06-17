variable "bin_dir" {
  type = string
}

variable "get_views_count_lambda_dir" {
  type = string
}

locals {
  get_views_count_lambda_zip_path = "${var.bin_dir}/get_views_count_lambda.zip"
}

data "archive_file" "get_views_count_lambda_zip" {
  type        = "zip"
  source_dir  = var.get_views_count_lambda_dir
  output_path = local.get_views_count_lambda_zip_path
}

resource "aws_lambda_function" "static_website_api_views_count_get" {
  filename         = local.get_views_count_lambda_zip_path
  function_name    = "${var.project_name}_get_views_count"
  handler          = "main.handler"
  runtime          = "python3.12"
  role             = aws_iam_role.lambda_dynamodb_full_access.arn
  source_code_hash = data.archive_file.get_views_count_lambda_zip.output_base64sha256
  environment {
    variables = {
      table_name = local.views_count_table_name
    }
  }
}
