variable "project_name" { type = string }

locals {
  views_count_table_name = "${var.project_name}_views_count"
}
