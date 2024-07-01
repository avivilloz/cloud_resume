module "lambda_invoke" {
  source = "../iam_roles/lambda_invoke"
}

resource "aws_api_gateway_rest_api" "api_gateway" {
  name = local.api_name
  body = templatefile(local.openapi_path, merge(
    { iam_role_arn = module.lambda_invoke.role_arn },
    { for lambda_name, lambda_arn in var.lambdas_arns : "${lambda_name}_lambda_arn" => lambda_arn }
  ))

  endpoint_configuration {
    types = ["EDGE"]
  }
}

resource "aws_api_gateway_deployment" "api_gateway" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.api_gateway.body))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "api_gateway" {
  deployment_id = aws_api_gateway_deployment.api_gateway.id
  rest_api_id   = aws_api_gateway_rest_api.api_gateway.id
  stage_name    = var.stage_name
}

# -----------------------------------------------------------------------------
# CUSTOM DOMAIN NAME

resource "aws_api_gateway_domain_name" "api_gateway" {
  count           = var.custom_domain_name != "" ? 1 : 0
  certificate_arn = var.acm_certificate_arn
  domain_name     = local.api_domain_name
}

resource "aws_api_gateway_base_path_mapping" "api_gateway" {
  count       = var.custom_domain_name != "" ? 1 : 0
  api_id      = aws_api_gateway_rest_api.api_gateway.id
  stage_name  = aws_api_gateway_stage.api_gateway.stage_name
  domain_name = aws_api_gateway_domain_name.api_gateway[count.index].domain_name
}

# -----------------------------------------------------------------------------
# DNS RECORD

data "cloudflare_zone" "api_gateway" {
  name = var.custom_domain_name
}

resource "cloudflare_record" "api_gateway" {
  count           = var.custom_domain_name != "" ? 1 : 0
  zone_id         = data.cloudflare_zone.api_gateway.zone_id
  name            = local.api_domain_name
  value           = aws_api_gateway_domain_name.api_gateway[count.index].cloudfront_domain_name
  type            = "CNAME"
  allow_overwrite = true
}
