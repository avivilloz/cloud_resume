data "archive_file" "get_views_count_lambda_zip" {
  type        = "zip"
  source_dir  = local.get_views_count_lambda_dir
  output_path = local.get_views_count_lambda_zip_path
}

resource "aws_lambda_function" "get_views_count" {
  filename         = local.get_views_count_lambda_zip_path
  function_name    = local.get_views_count_lambda_function_name
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
