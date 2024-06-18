

resource "cloudflare_record" "static_website" {
  allow_overwrite = true
  zone_id         = data.cloudflare_zone.static_website.zone_id
  name            = var.domain_name
  value           = aws_cloudfront_distribution.static_website.domain_name
  type            = "CNAME"
}

resource "cloudflare_record" "static_website_api" {
  allow_overwrite = true
  zone_id         = data.cloudflare_zone.static_website.zone_id
  name            = local.api_domain_name
  value           = aws_api_gateway_domain_name.api.cloudfront_domain_name
  type            = "CNAME"
}
