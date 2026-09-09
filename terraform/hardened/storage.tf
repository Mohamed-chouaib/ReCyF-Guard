resource "aws_s3_bucket" "access_logs" {
  #checkov:skip=CKV_AWS_18:Access-log target; logging to itself would recurse
  #checkov:skip=CKV_AWS_144:Single-region lab, CRR out of scope
  #checkov:skip=CKV2_AWS_62:No event consumer required for a log sink
  bucket        = "recyf-hardened-access-logs"
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "access_logs" {
  bucket                  = aws_s3_bucket.access_logs.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "access_logs" {
  bucket = aws_s3_bucket.access_logs.id
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.main.arn
      sse_algorithm     = "aws:kms"
    }
    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket_versioning" "access_logs" {
  bucket = aws_s3_bucket.access_logs.id
  versioning_configuration { status = "Enabled" }
}

resource "aws_s3_bucket_lifecycle_configuration" "access_logs" {
  bucket = aws_s3_bucket.access_logs.id
  rule {
    id     = "expire-old-logs"
    status = "Enabled"
    filter {}
    expiration { days = 400 }
    noncurrent_version_expiration { noncurrent_days = 90 }
  }
}

# ---- primary data bucket ----

resource "aws_s3_bucket" "data" {
  #checkov:skip=CKV_AWS_144:Single-region lab, CRR out of scope
  bucket        = "recyf-hardened-data"
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "data" {
  bucket                  = aws_s3_bucket.data.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "data" {
  bucket = aws_s3_bucket.data.id
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.main.arn
      sse_algorithm     = "aws:kms"
    }
    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket_versioning" "data" {
  bucket = aws_s3_bucket.data.id
  versioning_configuration { status = "Enabled" }
}

resource "aws_s3_bucket_logging" "data" {
  bucket        = aws_s3_bucket.data.id
  target_bucket = aws_s3_bucket.access_logs.id
  target_prefix = "s3-access/"
}

resource "aws_s3_bucket_lifecycle_configuration" "data" {
  bucket = aws_s3_bucket.data.id
  rule {
    id     = "transition-and-expire"
    status = "Enabled"
    filter {}
    noncurrent_version_expiration { noncurrent_days = 90 }
  }
}

resource "aws_sns_topic" "s3_events" {
  name              = "recyf-hardened-s3-events"
  kms_master_key_id = aws_kms_key.main.id
}

resource "aws_sns_topic_policy" "s3_events" {
  arn = aws_sns_topic.s3_events.arn
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "s3.amazonaws.com" }
      Action    = "SNS:Publish"
      Resource  = aws_sns_topic.s3_events.arn
      Condition = { ArnLike = { "aws:SourceArn" = aws_s3_bucket.data.arn } }
    }]
  })
}

resource "aws_s3_bucket_notification" "data" {
  bucket = aws_s3_bucket.data.id
  topic {
    topic_arn = aws_sns_topic.s3_events.arn
    events    = ["s3:ObjectCreated:*"]
  }
  depends_on = [aws_sns_topic_policy.s3_events]
}
