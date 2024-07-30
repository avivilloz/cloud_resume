variable "project_name" { type = string }
variable "project_base_dir" { type = string }
variable "lambdas_arns" { type = map(any) }
variable "domain_name" { type = string }
variable "api_domain_name" { type = string }
variable "acm_certificate_arn" { type = string }

locals {
  api_name     = var.project_name
  openapi_path = "${var.project_base_dir}/backend/api/openapi.yaml"
}
