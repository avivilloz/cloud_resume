resource "ansible_playbook" "deployment" {
  playbook   = var.deployment_file_path
  name       = "localhost"
  replayable = true
  extra_vars = {
    s3_files_dir               = var.s3_files_dir
    s3_bucket_name             = aws_s3_bucket.s3.id
    cloudfront_distribution_id = aws_cloudfront_distribution.cloudfront.id
  }
}
