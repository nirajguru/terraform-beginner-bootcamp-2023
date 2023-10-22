terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "random_string" "bucket_name" {
  # Bucket naming rules https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html
  length  = 16
  special = false
  lower   = true
  upper   = false
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = random_string.bucket_name.id
  tags = {
    UserUuid = var.user_uuid
  }
}

resource "aws_s3_bucket_website_configuration" "s3_website" {
  bucket = aws_s3_bucket.my_bucket.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_object" "index_file" {
  bucket = aws_s3_bucket.my_bucket.bucket
  key    = "index.html"
  source = "${path.root}/public/index.html"
  etag   = filemd5("${path.root}/public/index.html")
}

resource "aws_s3_object" "error_file" {
  bucket = aws_s3_bucket.my_bucket.bucket
  key    = "error.html"
  source = "${path.root}/public/error.html"
  etag   = filemd5("${path.root}/public/error.html")
}