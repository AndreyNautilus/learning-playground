# TODO: for now the replica is hosted in the same region.
#       To have it in another region, we need a second aws provider and
#       specify provider for every resource, which is cumbersome.

resource "aws_s3_bucket" "replica-bucket" {
  bucket        = "${aws_s3_bucket.main-bucket.bucket}-replica"
  force_destroy = true # allow destroy with objects
}

resource "aws_s3_bucket_versioning" "replica-bucket-versioning" {
  bucket = aws_s3_bucket.replica-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "replication" {
  name               = "${aws_s3_bucket.main-bucket.bucket}-role-replication"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "replication" {
  statement {
    effect = "Allow"
    actions = [
      "s3:ListBucket",
      "s3:GetReplicationConfiguration",
      "s3:GetObjectVersionForReplication",
      "s3:GetObjectVersionAcl",
      "s3:GetObjectVersionTagging",
      "s3:GetObjectRetention",
      "s3:GetObjectLegalHold"
    ]
    resources = [
      "${aws_s3_bucket.main-bucket.arn}",
      "${aws_s3_bucket.main-bucket.arn}/*",
      "${aws_s3_bucket.replica-bucket.arn}",
      "${aws_s3_bucket.replica-bucket.arn}/*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:ReplicateObject",
      "s3:ReplicateDelete",
      "s3:ReplicateTags",
      "s3:ObjectOwnerOverrideToBucketOwner"
    ]
    resources = [
      "${aws_s3_bucket.main-bucket.arn}/*",
      "${aws_s3_bucket.replica-bucket.arn}/*"
    ]
  }
}

resource "aws_iam_policy" "replication" {
  name   = "${aws_s3_bucket.main-bucket.bucket}-policy-replication"
  policy = data.aws_iam_policy_document.replication.json
}

resource "aws_iam_role_policy_attachment" "replication" {
  role       = aws_iam_role.replication.name
  policy_arn = aws_iam_policy.replication.arn
}

resource "aws_s3_bucket_replication_configuration" "replication" {
  depends_on = [
    aws_s3_bucket_versioning.main-bucket-versioning,
    aws_s3_bucket_versioning.replica-bucket-versioning
  ]

  bucket = aws_s3_bucket.main-bucket.id
  role   = aws_iam_role.replication.arn
  rule {
    id = "DemoReplicationRule"

    status = "Enabled"

    destination {
      bucket = aws_s3_bucket.replica-bucket.arn
    }
  }
}
