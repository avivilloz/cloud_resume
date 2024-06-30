variable "s3_website_endpoint" { type = string }

variable "custom_domain_name" {
  type    = string
  default = ""
}

variable "acm_certificate_arn" {
  type    = string
  default = ""
}
