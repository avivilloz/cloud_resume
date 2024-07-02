data "archive_file" "lambda_zip_files" {
  for_each    = local.lambda_names
  type        = "zip"
  source_file = "${local.lambda_py_files_dir}/${each.value}.py"
  output_path = "${local.lambda_zip_files_dir}/${each.value}.zip"
}

module "dynamodb_full_access" {
  source       = "../iam_roles/dynamodb_full_access"
  project_name = var.project_name
}

resource "aws_lambda_function" "lambdas" {
  for_each         = local.lambda_names
  filename         = "${local.lambda_zip_files_dir}/${each.value}.zip"
  function_name    = "${var.project_name}_${each.value}"
  handler          = "${each.value}.handler"
  runtime          = "python3.12"
  role             = module.dynamodb_full_access.role_arn
  source_code_hash = data.archive_file.lambda_zip_files[each.value].output_base64sha256

  environment {
    variables = {
      table_name = local.views_count_table_name
    }
  }
}
