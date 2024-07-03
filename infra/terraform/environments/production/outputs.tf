output "s3_bucket_name" {
  value = module.s3_bucket.s3_bucket_name
}

output "api_stage_endpoint" {
  value = module.api_gateway.api_stage_endpoint
}

output "cloudfront_distribution_id" {
  value = module.cloudfront.cloudfront_id
}
