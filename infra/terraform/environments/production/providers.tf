terraform {
  required_providers {

    aws = {
      source  = "hashicorp/aws"
      version = "5.52.0"
    }

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.34.0"
    }

  }
}

provider "aws" {
  region     = "us-east-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}
