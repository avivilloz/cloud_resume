variable "project_name" { type = string }

locals {
  s3_bucket_name = replace(var.project_name, "_", "-")
}
