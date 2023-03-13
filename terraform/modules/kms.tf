module "kms" {
  source = "git::https://github.com/dod-iac/terraform-aws-cloudwatch-kms-key.git//.?ref=v1.0.1"
  
  name = "alias/ecs_logging"
}
