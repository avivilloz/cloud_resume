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
  source           = "../../modules/api_gateway"
  project_name     = var.project_name
  project_base_dir = var.project_base_dir
  stage_name       = var.api_stage_name
  lambdas_arns     = module.lambdas.arns
}
