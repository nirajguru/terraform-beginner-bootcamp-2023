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
  content_type = "text/html"
  lifecycle {
    ignore_changes = [etag]
    replace_triggered_by = [ terraform_data.content_version.output ]
    } 
}


resource "aws_s3_object" "error_file" {
  bucket = aws_s3_bucket.my_bucket.bucket
  key    = "error.html"
  source = "${path.root}/public/error.html"
  etag   = filemd5("${path.root}/public/error.html")
  content_type = "text/html"
  lifecycle {
    ignore_changes = [ etag ]
    replace_triggered_by = [ terraform_data.content_version.output ]
  }
}

resource "aws_s3_object" "upload_assets" {

  for_each = fileset("${path.root}/public/assets","*.{jpg}")
  bucket = aws_s3_bucket.my_bucket.bucket
  key    = "assets/${each.key}"
  source = "${path.root}/public/assets/${each.key}"
  etag   = filemd5("${path.root}/public/assets/${each.key}")
  content_type = "text/html"
  lifecycle {
    ignore_changes = [ etag ]
    replace_triggered_by = [ terraform_data.content_version.output ]
  }
}


resource "aws_s3_bucket_policy" "my_bucket_policy" {
  bucket = aws_s3_bucket.my_bucket.id
  policy = jsonencode({
    "Version" = "2012-10-17",
    "Statement" = {
        "Sid" = "AllowCloudFrontServicePrincipalReadOnly",
        "Effect" = "Allow",
        "Principal" = {
            "Service" = "cloudfront.amazonaws.com"
        },
        "Action" = "s3:GetObject",
        "Resource" = "arn:aws:s3:::${aws_s3_bucket.my_bucket.bucket}/*",
        "Condition" = {
            "StringEquals" = {
                "AWS:SourceArn" = "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/${aws_cloudfront_distribution.s3_distribution.id}"
            }
        }
    }
  })
}

resource "terraform_data" "content_version" {
  input = var.content_version  
}