# FIXTURE: intentionally vulnerable.

resource "aws_cloudwatch_log_group" "app" {
  name = "/recyf/lab/app"
  # No retention_in_days, no kms_key_id: intentional
}

resource "aws_kms_key" "no_rotation" {
  description             = "Lab key, rotation disabled"
  enable_key_rotation     = false
  deletion_window_in_days = 7
}

resource "aws_secretsmanager_secret" "db" {
  name = "recyf/lab/db-credentials"
  # No kms_key_id, no rotation: intentional
}

resource "aws_cloudtrail" "lab" {
  name                          = "recyf-lab-trail"
  s3_bucket_name                = aws_s3_bucket.trail_logs.id
  is_multi_region_trail         = false
  include_global_service_events = false
  enable_log_file_validation    = false
  depends_on                    = [aws_s3_bucket_policy.trail_logs]
}
