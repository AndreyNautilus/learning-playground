resource "aws_s3_bucket_website_configuration" "main-bucket-website" {
  bucket = aws_s3_bucket.main-bucket.id

  index_document {
    suffix = "index.html"
  }
}

locals {
  website_dir = "website"
}

resource "null_resource" "main-bucket-website-index_html" {
  depends_on = [
    aws_s3_bucket.main-bucket,
    aws_s3_bucket_replication_configuration.replication
  ]

  provisioner "local-exec" {
    command = "aws s3 cp ./${local.website_dir} s3://${aws_s3_bucket.main-bucket.bucket}/ --recursive"
  }

  triggers = {
    # Only re-run if the files change — not if bucket changes
    file_hash = sha1(join("", [for f in fileset("${local.website_dir}", "**") : filesha1("${local.website_dir}/${f}")]))
  }
}
