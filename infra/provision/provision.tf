terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.52.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "avivilloz" {
  bucket = "avivilloz"
}

resource "aws_s3_bucket_ownership_controls" "avivilloz" {
  bucket = aws_s3_bucket.avivilloz.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "avivilloz" {
  bucket = aws_s3_bucket.avivilloz.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_website_configuration" "avivilloz" {
  bucket = aws_s3_bucket.avivilloz.id

  index_document {
    suffix = "index.html"
  }
}

resource "aws_cloudfront_distribution" "avivilloz" {
  enabled = true
  aliases = "avivilloz.com"

  origin {
    domain_name = aws_s3_bucket.avivilloz.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.avivilloz.bucket_regional_domain_name
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  default_cache_behavior {
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = aws_s3_bucket.avivilloz.bucket_regional_domain_name
    viewer_protocol_policy = "allow-all"
    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }
}
