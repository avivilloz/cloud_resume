variable "openapi_path" {
  type = string
}

locals {
  api_name        = var.project_name
  openapi_path    = var.openapi_path
  domain_name     = var.domain_name
}

resource "aws_api_gateway_rest_api" "api" {
  name = local.api_name

  body = templatefile(local.openapi_path, {
    domain_name                         = local.domain_name
    get_views_count_lambda_arn          = aws_lambda_function.get_views_count.invoke_arn
    get_views_count_lambda_iam_role_arn = aws_iam_role.lambda_dynamodb_full_access.arn
  })

  endpoint_configuration {
    types = ["EDGE"]
  }
}

resource "aws_api_gateway_deployment" "api" {
  rest_api_id = aws_api_gateway_rest_api.api.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.api.body))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "api" {
  deployment_id = aws_api_gateway_deployment.api.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
  stage_name    = "api"
}

resource "aws_api_gateway_domain_name" "api" {
  certificate_arn = aws_acm_certificate_validation.static_website.certificate_arn
  domain_name     = local.api_domain_name
}

resource "aws_api_gateway_base_path_mapping" "api" {
  api_id      = aws_api_gateway_rest_api.api.id
  stage_name  = aws_api_gateway_stage.api.stage_name
  domain_name = aws_api_gateway_domain_name.api.domain_name
}
