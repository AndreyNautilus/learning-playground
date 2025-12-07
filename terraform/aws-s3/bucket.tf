resource "aws_s3_bucket" "main-bucket" {
  bucket = "andreynautilus-s3-demo-v2"

  tags = {
    Name = "AN Demo bucket"
  }
}

resource "aws_s3_bucket_versioning" "main-bucket-versioning" {
  bucket = aws_s3_bucket.main-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "main-bucket-public-access" {
  bucket = aws_s3_bucket.main-bucket.id

  block_public_acls       = false
  block_public_policy     = true
  ignore_public_acls      = false
  restrict_public_buckets = true
}
