output "bucket_name" {
  value = random_string.bucket_name.id
}

output "s3_website_url" {
  value = aws_s3_bucket_website_configuration.s3_website.website_endpoint
}