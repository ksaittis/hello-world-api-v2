module alb_sg {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-security-group.git//.?ref=v4.9.0"

  name        = "${var.project_name}-${var.deployment_name}-alb-sg"
  vpc_id      = module.vpc.outputs.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["https-443-tcp", "http-80-tcp"]

  egress_rules = ["all-all"]
}
