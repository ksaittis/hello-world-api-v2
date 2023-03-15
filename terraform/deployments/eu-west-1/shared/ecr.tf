data "aws_caller_identity" "current" {}

module "ecr" {
  source = "terraform-aws-modules/ecr/aws"

  repository_name                   = var.repository_name
  repository_read_write_access_arns = [data.aws_caller_identity.current.arn]
  repository_force_delete           = false

  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 10 images",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["v"],
          countType     = "imageCountMoreThan",
          countNumber   = 19
        },
        action = {
          type = "expire"
        }
      }
    ]
  })
}
