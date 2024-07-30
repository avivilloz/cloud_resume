output "s3_bucket_name" {
  value = module.s3_bucket.s3_bucket_name
}

output "cloudfront_distribution_id" {
  value = module.cloudfront.cloudfront_distribution_id
}

output "website_url" {
  value = "https://${var.subdomain_name}"
}

output "api_url" {
  value = "https://${var.api_domain_name}"
}
