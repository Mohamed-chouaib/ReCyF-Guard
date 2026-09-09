# region / localstack_endpoint are declared in ../provider.tf (symlinked here).

variable "deploy_licensed_services" {
  type    = bool
  default = false
}

data "aws_caller_identity" "current" {}
