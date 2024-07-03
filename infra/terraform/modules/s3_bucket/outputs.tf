output "s3_bucket_name" {
  value = local.s3_bucket_name
}

output "s3_website_endpoint" {
  value = aws_s3_bucket_website_configuration.s3.website_endpoint
}
