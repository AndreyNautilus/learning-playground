output "website_url" {
  value       = aws_s3_bucket_website_configuration.main-bucket-website.website_endpoint
  description = "Website endpoint"
}
