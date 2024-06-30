resource "aws_cloudfront_distribution" "cloudfront" {
  enabled = true
  aliases = [var.custom_domain_name]

  origin {
    domain_name = var.s3_website_endpoint
    origin_id   = var.s3_website_endpoint

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
    acm_certificate_arn            = var.acm_certificate_arn
    cloudfront_default_certificate = var.acm_certificate_arn == "" ? true : false
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "TLSv1.2_2021"
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = var.s3_website_endpoint
    viewer_protocol_policy = "allow-all"
    cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6"
  }
}

# -----------------------------------------------------------------------------
# DNS RECORD

data "cloudflare_zone" "cloudfront" {
  name = var.custom_domain_name
}

resource "cloudflare_record" "cloudfront" {
  count           = var.custom_domain_name != "" ? 1 : 0
  allow_overwrite = true
  zone_id         = data.cloudflare_zone.cloudfront.zone_id
  name            = var.custom_domain_name
  value           = aws_cloudfront_distribution.cloudfront.domain_name
  type            = "CNAME"
}
