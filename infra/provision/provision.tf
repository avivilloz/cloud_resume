terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.52.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "resume_s3b" {
  bucket = "resume-aviv-illoz"
}

resource "aws_s3_bucket_public_access_block" "resume_s3b" {
  bucket = aws_s3_bucket.resume_s3b.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
