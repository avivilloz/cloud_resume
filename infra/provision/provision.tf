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
  region = "us-east-1"
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

variable "cloudflare_api_token" {
  type      = string
  sensitive = true
}

variable "project_name" {
  type = string
}

variable "domain_name" {
  type = string
}

variable "api_json_path" {
  type = string
}

variable "get_views_count_path" {
  type = string
}

locals {
  api_domain_name = "api.${var.domain_name}"
}

resource "aws_s3_bucket" "static_website" {
  bucket = var.project_name
}

resource "aws_s3_bucket_ownership_controls" "static_website" {
  bucket = aws_s3_bucket.static_website.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "static_website" {
  bucket = aws_s3_bucket.static_website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_website_configuration" "static_website" {
  bucket = aws_s3_bucket.static_website.id

  index_document {
    suffix = "index.html"
  }
}

resource "aws_acm_certificate" "static_website" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  subject_alternative_names = [
    "*.${var.domain_name}"
  ]
}

resource "cloudflare_record" "static_website_acm_certificate" {
  for_each = {
    for dvo in aws_acm_certificate.static_website.domain_validation_options :
    dvo.domain_name => {
      name  = dvo.resource_record_name
      value = dvo.resource_record_value
      type  = dvo.resource_record_type
    } if dvo.domain_name == var.domain_name
  }

  allow_overwrite = true
  zone_id         = data.cloudflare_zone.static_website.zone_id
  name            = each.value.name
  value           = each.value.value
  type            = each.value.type
}

data "cloudflare_zone" "static_website" {
  name = var.domain_name
}

resource "aws_acm_certificate_validation" "static_website" {
  certificate_arn = aws_acm_certificate.static_website.arn
}

resource "aws_cloudfront_distribution" "static_website" {
  enabled = true
  aliases = [var.domain_name]

  origin {
    domain_name = aws_s3_bucket_website_configuration.static_website.website_endpoint
    origin_id   = aws_s3_bucket_website_configuration.static_website.website_endpoint

    custom_origin_config {
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
      http_port              = 80
      https_port             = 443
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate_validation.static_website.certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = aws_s3_bucket_website_configuration.static_website.website_endpoint
    viewer_protocol_policy = "allow-all"
    cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6"
  }
}

resource "cloudflare_record" "static_website" {
  allow_overwrite = true
  zone_id         = data.cloudflare_zone.static_website.zone_id
  name            = var.domain_name
  value           = aws_cloudfront_distribution.static_website.domain_name
  type            = "CNAME"
}

resource "aws_api_gateway_domain_name" "static_website_api" {
  certificate_arn = aws_acm_certificate_validation.static_website.certificate_arn
  domain_name     = local.api_domain_name
}

resource "cloudflare_record" "static_website_api" {
  allow_overwrite = true
  zone_id         = data.cloudflare_zone.static_website.zone_id
  name            = local.api_domain_name
  value           = aws_api_gateway_domain_name.static_website_api.cloudfront_domain_name
  type            = "CNAME"
}

resource "aws_dynamodb_table" "static_website_views_count" {
  name         = "${var.project_name}_views_count"
  hash_key     = "id"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "id"
    type = "N"
  }
}

data "aws_iam_policy_document" "lambda_dynamodb_full_access" {
  statement {
    effect = "Allow"
    actions = [
      "dynamodb:*"
    ]
    resources = ["arn:aws:dynamodb:*:*:*"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda_dynamodb_full_access" {
  name               = "lambda_dynamodb_full_access"
  assume_role_policy = data.aws_iam_policy_document.lambda_dynamodb_full_access.json
}


resource "aws_lambda_function" "static_website_api_views_count_get" {
  filename      = var.get_views_count_path
  function_name = "get_views_count"
  handler       = "get_views_count"
  runtime       = "python3.12"
  role          = aws_iam_role.lambda_dynamodb_full_access.arn
}

# resource "aws_api_gateway_rest_api" "static_website_api" {
#   name = var.project_name
#   body = file(var.api_json_path)
# }
