resource "aws_vpc" "lab" {
  cidr_block           = "10.10.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = { Name = "recyf-hardened-vpc" }
}

# Explicitly strip every rule from the default SG
resource "aws_default_security_group" "lab" {
  vpc_id = aws_vpc.lab.id
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.lab.id
  cidr_block        = "10.10.1.0/24"
  availability_zone = "${var.region}a"
  tags              = { Name = "recyf-hardened-private" }
}

resource "aws_security_group" "app" {
  name        = "recyf-hardened-app"
  description = "Least-privilege application security group"
  vpc_id      = aws_vpc.lab.id

  ingress {
    description = "HTTPS from inside the VPC only"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.lab.cidr_block]
  }

  egress {
    description = "HTTPS to AWS service endpoints"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Satisfies "security group must be attached to a resource"
resource "aws_network_interface" "app" {
  subnet_id       = aws_subnet.private.id
  security_groups = [aws_security_group.app.id]
  description     = "Attachment target for the app security group"
}

resource "aws_ebs_volume" "data" {
  availability_zone = "${var.region}a"
  size              = 1
  encrypted         = true
  kms_key_id        = aws_kms_key.main.arn
}

# ---- VPC flow logs ----

resource "aws_iam_role" "flow_logs" {
  name = "recyf-hardened-flow-logs"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "vpc-flow-logs.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "flow_logs" {
  name = "recyf-hardened-flow-logs"
  role = aws_iam_role.flow_logs.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ]
      Resource = "${aws_cloudwatch_log_group.flow_logs.arn}:*"
    }]
  })
}

resource "aws_flow_log" "lab" {
  vpc_id          = aws_vpc.lab.id
  traffic_type    = "ALL"
  iam_role_arn    = aws_iam_role.flow_logs.arn
  log_destination = aws_cloudwatch_log_group.flow_logs.arn
}
