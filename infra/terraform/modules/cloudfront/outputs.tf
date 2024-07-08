output "cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.cloudfront.id
}

output "website_url" {
  value = var.custom_domain_name == "" ? aws_cloudfront_distribution.cloudfront.domain_name : var.custom_domain_name
}
