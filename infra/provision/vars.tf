variable "cloudflare_api_token" {
  type      = string
  sensitive = true
}

variable "aws_region" {
  type = string
}

variable "project_name" {
  type = string
}

variable "domain_name" {
  type = string
}

variable "openapi_path" {
  type = string
}

variable "deployment_file_path" {
  type = string
}

variable "s3_files_dir" {
  type = string
}

variable "temp_dir" {
  type = string
}

variable "get_views_count_lambda_dir" {
  type = string
}

locals {
  api_name                        = var.project_name
  api_domain_name                 = "api.${var.domain_name}"
  views_count_table_name          = "${var.project_name}_views_count"
  get_views_count_lambda_zip_path = "${var.temp_dir}/get_views_count_lambda.zip"
}
