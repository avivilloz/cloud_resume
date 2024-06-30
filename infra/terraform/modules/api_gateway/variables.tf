variable "project_name" { type = string }
variable "project_base_dir" { type = string }
variable "stage_name" { type = string }
variable "lambdas_arns" { type = map(any) }

variable "custom_domain_name" {
  type    = string
  default = ""
}

variable "acm_certificate_arn" {
  type    = string
  default = ""
}

locals {
  api_name        = var.project_name
  api_domain_name = "api.${var.custom_domain_name}"
  openapi_path    = "${var.project_base_dir}/backend/api/openapi.yaml"
}
