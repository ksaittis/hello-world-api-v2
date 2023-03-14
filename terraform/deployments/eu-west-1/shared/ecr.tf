variable "repository_name" {
  type    = string
  default = "hello-world-api"
}

data "aws_caller_identity" "current" {}


module "ecr" {
  source = "terraform-aws-modules/ecr/aws"

  repository_name                   = var.repository_name
  repository_read_write_access_arns = [data.aws_caller_identity.current.arn]
  repository_force_delete           = false
}
