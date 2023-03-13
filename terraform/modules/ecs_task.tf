module "ecs_task" {
  source = "git::https://github.com/trussworks/terraform-aws-ecs-service//.?ref=v6.6.0"

  ecs_cluster = {
    arn  = module.ecs_cluster.arn
    name = module.ecs_cluster.cluster_name
  }

  name                          = "${var.deployment_name}-hello-world-api"
  ecs_vpc_id                    = dependency.vpc.outputs.vpc_id
  ecs_subnet_ids                = dependency.vpc.outputs.private_subnets
  
  ecs_use_fargate               = true
  additional_security_group_ids = [dependency.vpc.outputs.default_security_group_id]
  container_definitions         = <<DEFINITION
  [{
    "name": "${var.deployment_name}_server",
    "image": "public.ecr.aws/n6z6p5x6/kostas-test/server:0.2.0",
    "essential": true,
    "requiresCompatibilities": [ 
      "FARGATE" 
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
          "awslogs-group": "/ecs/"${project_name}"/"${var.deployment_name}/hello-world-api",
          "awslogs-region": "${var.region}",
          "awslogs-stream-prefix": "ecs"
      }
    },
    "portMappings": [
      {
        "name": "server-3030-tcp",
        "containerPort": 3030,
        "protocol": "tcp",
        "appProtocol": "http"
      }
    ],
    "cpu": 256,
    "family": "fargate-task-definition",
    "memory": 512
  }]
  DEFINITION
  tasks_desired_count           = 1
  kms_key_id                    = module.kms.outputs.aws_kms_key_arn
  associate_alb                 = true
  environment                   = "dev"
  target_container_name         = "server"
  alb_security_group            = dependency.alb_sg.outputs.security_group_id
  lb_target_groups = [
    {
      container_port              = 3030
      container_health_check_port = 3030
      lb_target_group_arn         = dependency.alb.outputs.target_group_arns[1]
    }
  ]
}
