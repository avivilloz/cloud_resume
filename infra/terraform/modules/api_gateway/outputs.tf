output "api_stage_endpoint" {
  value = var.custom_domain_name == "" ? aws_api_gateway_stage.api_gateway.invoke_url : "https://${local.api_domain_name}"
}
