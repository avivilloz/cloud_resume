variable "project_name" { type = string }
variable "project_base_dir" { type = string }

locals {
  views_count_table_name = "${var.project_name}_views_count"
  lambda_py_files_dir    = "${var.project_base_dir}/backend/lambdas"
  lambda_zip_files_dir   = "${var.project_base_dir}/temp/lambdas"
  lambda_names           = toset([for lambda in fileset(local.lambda_py_files_dir, "*.py") : trimsuffix(lambda, ".py")])
}
