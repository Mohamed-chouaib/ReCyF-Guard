terraform {
  required_version = "~> 1.9"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.60"
    }
  }
}

variable "region" {
  type    = string
  default = "eu-west-3"
}

variable "localstack_endpoint" {
  description = "Set to empty string to target a real AWS account instead."
  type        = string
  default     = "http://localhost:4566"
}

provider "aws" {
  region = var.region

  access_key                  = var.localstack_endpoint != "" ? "test" : null
  secret_key                  = var.localstack_endpoint != "" ? "test" : null
  s3_use_path_style           = var.localstack_endpoint != ""
  skip_credentials_validation = var.localstack_endpoint != ""
  skip_metadata_api_check     = var.localstack_endpoint != ""
  skip_requesting_account_id  = var.localstack_endpoint != ""

  dynamic "endpoints" {
    for_each = var.localstack_endpoint != "" ? [1] : []
    content {
      s3             = var.localstack_endpoint
      iam            = var.localstack_endpoint
      sts            = var.localstack_endpoint
      ec2            = var.localstack_endpoint
      kms            = var.localstack_endpoint
      logs           = var.localstack_endpoint
      secretsmanager = var.localstack_endpoint
      lambda         = var.localstack_endpoint
      events         = var.localstack_endpoint
      cloudtrail     = var.localstack_endpoint
    }
  }

  default_tags {
    tags = {
      Project     = "recyf-guard"
      Environment = "lab"
      ManagedBy   = "terraform"
      AutoDestroy = "true"
    }
  }
}
