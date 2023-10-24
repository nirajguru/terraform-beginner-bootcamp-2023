output "bucket_name" {
  value = random_string.bucket_name.id
}

output "s3_website_url" {
  value = aws_s3_bucket_website_configuration.s3_website.website_endpoint
}

output "cloudfront_url" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name  
}