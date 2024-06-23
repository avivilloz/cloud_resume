resource "ansible_playbook" "deployment" {
  playbook   = local.deployment_file_path
  name       = "localhost"
  replayable = true
  extra_vars = {
    temp_dir                   = local.temp_dir
    s3_files_dir               = local.s3_files_dir
    s3_bucket_name             = aws_s3_bucket.s3.id
    views_count_api_endpoint   = local.views_count_api_endpoint
    cloudfront_distribution_id = aws_cloudfront_distribution.cloudfront.id
  }
}
