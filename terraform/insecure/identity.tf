# FIXTURE: intentionally vulnerable.

resource "aws_iam_user" "app" {
  name          = "recyf-lab-app"
  force_destroy = true
}

resource "aws_iam_user_policy" "admin" {
  name = "recyf-lab-full-admin"
  user = aws_iam_user.app.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = "*"
      Resource = "*"
    }]
  })
}

resource "aws_iam_role" "trust_anyone" {
  name = "recyf-lab-open-trust"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { AWS = "*" }
      Action    = "sts:AssumeRole"
    }]
  })
}
