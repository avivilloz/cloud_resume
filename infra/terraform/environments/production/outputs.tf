output "s3_bucket_name" {
  value = module.s3_bucket.s3_bucket_name
}

output "api_url" {
  value = module.api_gateway.api_url
}

output "cloudfront_distribution_id" {
  value = module.cloudfront.cloudfront_distribution_id
}

output "website_url" {
  value = module.cloudfront.website_url
}
