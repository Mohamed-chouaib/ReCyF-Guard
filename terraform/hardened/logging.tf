resource "aws_cloudwatch_log_group" "app" {
  name              = "/recyf/hardened/app"
  retention_in_days = 365
  kms_key_id        = aws_kms_key.main.arn
}

resource "aws_cloudwatch_log_group" "flow_logs" {
  name              = "/recyf/hardened/flow-logs"
  retention_in_days = 365
  kms_key_id        = aws_kms_key.main.arn
}

resource "aws_secretsmanager_secret" "db" {
  #checkov:skip=CKV2_AWS_57:Automatic rotation needs a rotation Lambda; out of lab scope
  name       = "recyf/hardened/db-credentials"
  kms_key_id = aws_kms_key.main.arn
}

resource "aws_sns_topic" "trail_alerts" {
  name              = "recyf-hardened-trail-alerts"
  kms_master_key_id = aws_kms_key.main.id
}

resource "aws_cloudtrail" "main" {
  # Not deployable on LocalStack freemium; retained for static analysis.
  count = var.deploy_licensed_services ? 1 : 0

  name                          = "recyf-hardened-trail"
  s3_bucket_name                = aws_s3_bucket.access_logs.id
  is_multi_region_trail         = true
  include_global_service_events = true
  enable_log_file_validation    = true
  kms_key_id                    = aws_kms_key.main.arn
  sns_topic_name                = aws_sns_topic.trail_alerts.arn
  cloud_watch_logs_group_arn    = "${aws_cloudwatch_log_group.app.arn}:*"
  cloud_watch_logs_role_arn     = aws_iam_role.flow_logs.arn
}
