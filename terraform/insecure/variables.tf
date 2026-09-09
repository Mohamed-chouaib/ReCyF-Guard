# Variables region / localstack_endpoint are declared in ../provider.tf,
# which is symlinked into this module.

data "aws_caller_identity" "current" {}
