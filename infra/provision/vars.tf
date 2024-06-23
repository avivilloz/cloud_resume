variable "project_base_dir" {
  type = string
}

variable "project_name" {
  type = string
}

variable "domain_name" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "aws_access_key" {
  type      = string
  sensitive = true
}

variable "aws_secret_key" {
  type      = string
  sensitive = true
}

variable "cloudflare_api_token" {
  type      = string
  sensitive = true
}

locals {
  # base dirs
  frontend_dir = "${var.project_base_dir}/frontend"
  backend_dir  = "${var.project_base_dir}/backend"
  infra_dir    = "${var.project_base_dir}/infra"
  temp_dir     = "${var.project_base_dir}/temp"

  # s3
  s3_bucket_name = var.project_name
  s3_files_dir   = local.frontend_dir

  # dynamodb
  views_count_table_name = "${var.project_name}_views_count"

  # api
  api_name        = var.project_name
  api_domain_name = "api.${var.domain_name}"
  openapi_path    = "${local.backend_dir}/api/openapi.yaml"

  # lambda
  lambdas_dir                          = "${local.backend_dir}/lambdas"
  get_views_count_lambda_dir           = "${local.lambdas_dir}/get_views_count"
  get_views_count_lambda_zip_path      = "${local.temp_dir}/get_views_count_lambda.zip"
  get_views_count_lambda_function_name = "${var.project_name}_get_views_count"

  # deployment
  deployment_file_path     = "${local.infra_dir}/deployment/deployment.yaml"
  views_count_api_endpoint = "https://${local.api_domain_name}/views-count"
}
