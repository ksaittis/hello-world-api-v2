data "aws_availability_zones" "available" {}

locals {
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)
}

module vpc {
  source = "git::git@github.com:terraform-aws-modules/terraform-aws-vpc.git//.?ref=v3.14.0"
  name = var.project_name

  cidr = var.vpc_cidr

  azs             = local.azs
  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 4, k)]
  public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 48)]
  database_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 52)]

  create_database_subnet_group       = true
  create_database_subnet_route_table = true

  enable_dns_support   = true
  enable_dns_hostnames = true

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    "PROJECT_NAME" = var.project_name
    "DEPLOYMENT_NAME" = var.deployment_name
  }

  private_subnet_tags = {
    "scope" = "private"
  }

  public_subnet_tags = {
    "scope" = "public"
  }
}
