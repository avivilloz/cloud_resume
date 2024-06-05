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
  # Configuration options
}

variable "project_name" {
  type = string
}

locals {
  project_name = var.project_name
  domain_name  = format("%s.com", local.project_name)
}

resource "aws_s3_bucket" "static_website" {
  bucket = local.project_name
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

# resource "aws_acm_certificate" "acm_cert" {
#   domain_name       = local.domain_name
#   validation_method = "DNS"

#   subject_alternative_names = [
#     "*.${local.domain_name}" # Add wildcard for subdomains (optional)
#   ]

#   depends_on = [cloudflare_record.validation]
# }



# resource "aws_cloudfront_distribution" "static_website" {
#   enabled = true
#   aliases = [local.domain_name]

#   origin {
#     domain_name = aws_s3_bucket.static_website.bucket_regional_domain_name
#     origin_id   = aws_s3_bucket.static_website.bucket_regional_domain_name
#   }

#   restrictions {
#     geo_restriction {
#       restriction_type = "none"
#       locations        = []
#     }
#   }

#   viewer_certificate {
#     cloudfront_default_certificate = true
#   }

#   default_cache_behavior {
#     allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
#     cached_methods         = ["GET", "HEAD"]
#     target_origin_id       = aws_s3_bucket.static_website.bucket_regional_domain_name
#     viewer_protocol_policy = "allow-all"
#     forwarded_values {
#       query_string = false

#       cookies {
#         forward = "none"
#       }
#     }
#   }
# }
