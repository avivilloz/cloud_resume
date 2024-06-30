resource "aws_acm_certificate" "acm_certificate" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  subject_alternative_names = [
    "*.${var.domain_name}"
  ]

  lifecycle {
    create_before_destroy = true
  }
}

data "cloudflare_zone" "acm_certificate" {
  name = var.domain_name
}

resource "cloudflare_record" "acm_certificate" {
  for_each = {
    for dvo in aws_acm_certificate.acm_certificate.domain_validation_options :
    dvo.domain_name => {
      name  = dvo.resource_record_name
      value = dvo.resource_record_value
      type  = dvo.resource_record_type
    } if dvo.domain_name == var.domain_name
  }

  allow_overwrite = true
  zone_id         = data.cloudflare_zone.acm_certificate.zone_id
  name            = each.value.name
  value           = each.value.value
  type            = each.value.type
}

resource "aws_acm_certificate_validation" "acm_certificate" {
  certificate_arn = aws_acm_certificate.acm_certificate.arn
  depends_on      = [cloudflare_record.acm_certificate]
}
