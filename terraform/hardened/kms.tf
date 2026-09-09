resource "aws_kms_key" "main" {
  description             = "ReCyF-Guard hardened CMK"
  enable_key_rotation     = true
  deletion_window_in_days = 30

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid       = "EnableRootAccountPermissions"
      Effect    = "Allow"
      Principal = { AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root" }
      Action    = "kms:*"
      Resource  = "*"
    }]
  })
}

resource "aws_kms_alias" "main" {
  name          = "alias/recyf-hardened"
  target_key_id = aws_kms_key.main.key_id
}
