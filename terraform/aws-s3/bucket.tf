resource "aws_s3_bucket" "main-bucket" {
  bucket        = "andreynautilus-s3-demo-v2"
  force_destroy = true # allow destroy with objects

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
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "main-bucket-policy" {
  depends_on = [
    aws_s3_bucket_public_access_block.main-bucket-public-access
  ]

  bucket = aws_s3_bucket.main-bucket.id
  policy = replace(file("bucket_policy.json"), "BUCKET_NAME", aws_s3_bucket.main-bucket.bucket)
}

resource "aws_s3_bucket_lifecycle_configuration" "main-bucket-lifecycle-config" {
  depends_on = [aws_s3_bucket_versioning.main-bucket-versioning]

  bucket = aws_s3_bucket.main-bucket.id

  rule {
    id = "config"

    filter {} # all objects

    # move noncurrent versions to cheaper storage class
    noncurrent_version_transition {
      noncurrent_days = 30
      storage_class   = "STANDARD_IA"
    }

    # permanently delete noncurrent versions
    noncurrent_version_expiration {
      noncurrent_days = 90
    }

    # move current versions to cheaper storage class
    transition {
      days          = 60
      storage_class = "STANDARD_IA"
    }

    status = "Enabled"
  }
}
