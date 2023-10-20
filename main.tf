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

}

output "random_bucket_name" {
  value = random_string.bucket_name.id
}

