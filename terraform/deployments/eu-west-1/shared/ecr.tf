variable "repository_name" {
  type = string
  default = "hello-world-api"
}

module "ecr" {
  source = "terraform-aws-modules/ecr/aws"

  repository_name = var.repository_name
}
