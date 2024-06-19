data "cloudflare_zone" "static_website" {
  name = var.domain_name
}

# -----------------------------------------------------------------------------
# ACM_CERTIFICATE

resource "cloudflare_record" "acm_certificate" {
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

# -----------------------------------------------------------------------------
# WEBSITE

resource "cloudflare_record" "website" {
  allow_overwrite = true
  zone_id         = data.cloudflare_zone.static_website.zone_id
  name            = var.domain_name
  value           = aws_cloudfront_distribution.static_website.domain_name
  type            = "CNAME"
}

# -----------------------------------------------------------------------------
# API

resource "cloudflare_record" "api" {
  allow_overwrite = true
  zone_id         = data.cloudflare_zone.static_website.zone_id
  name            = local.api_domain_name
  value           = aws_api_gateway_domain_name.api.cloudfront_domain_name
  type            = "CNAME"
}
