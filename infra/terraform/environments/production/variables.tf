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

variable "project_name" { type = string }
variable "domain_name" { type = string }
variable "project_base_dir" { type = string }
variable "api_stage_name" { type = string }
