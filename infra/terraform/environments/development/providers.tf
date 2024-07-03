terraform {
  required_providers {

    aws = {
      source  = "hashicorp/aws"
      version = "5.52.0"
    }

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.36.0"
    }

  }
}

provider "aws" {
  region = "us-east-1"
}
