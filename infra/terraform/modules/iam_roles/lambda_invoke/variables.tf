variable "project_name" { type = string }

locals {
  rule_policy_name = "${var.project_name}_lambda_invoke"
}
