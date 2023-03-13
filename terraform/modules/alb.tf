
module alb {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-alb.git//.?ref=v6.10.0"

  name = var.project_name-var.deployment_name
  
  load_balancer_type = "application"

  vpc_id       = module.vpc.outputs.vpc_id
  subnets      = module.vpc.outputs.public_subnets
  idle_timeout = 300

  security_groups = [module.alb_sg.outputs.security_group_id]

  target_groups = [
    {
      name_prefix      = "iw"
      backend_protocol = "HTTP"
      backend_port     = 5000
      target_type      = "ip"
    }
  ]

  http_tcp_listeners = [
    {
      port               = 5000
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]
}
