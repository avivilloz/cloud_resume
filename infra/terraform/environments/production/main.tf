module "s3_bucket" {
  source       = "../../modules/s3_bucket"
  project_name = var.project_name
}

module "acm_certificate" {
  source      = "../../modules/acm_certificate"
  domain_name = var.domain_name
}

module "cloudfront" {
  source              = "../../modules/cloudfront"
  s3_website_endpoint = module.s3_bucket.s3_website_endpoint
  custom_domain_name  = var.domain_name
  acm_certificate_arn = module.acm_certificate.acm_certificate_arn
}

module "dynamodb_table" {
  source       = "../../modules/dynamodb_table"
  project_name = var.project_name
}

module "lambdas" {
  source           = "../../modules/lambdas"
  project_name     = var.project_name
  project_base_dir = var.project_base_dir
}

module "api_gateway" {
  source              = "../../modules/api_gateway"
  project_name        = var.project_name
  project_base_dir    = var.project_base_dir
  stage_name          = var.api_stage_name
  lambdas_arns        = module.lambdas.arns
  custom_domain_name  = var.domain_name
  acm_certificate_arn = module.acm_certificate.acm_certificate_arn
}
