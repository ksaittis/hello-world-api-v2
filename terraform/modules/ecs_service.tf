
module ecs_service {
  source = "git::https://github.com/trussworks/terraform-aws-ecs-service//.?ref=v6.6.0"
  ecs_cluster = {
    arn  = module.ecs_cluster.outputs.cluster_arn
    name = module.ecs_cluster.outputs.cluster_name
  }
  name                  = "service"
  ecs_vpc_id            = dependency.vpc.outputs.vpc_id
  ecs_subnet_ids        = dependency.vpc.outputs.private_subnets
  ecs_use_fargate       = true
  additional_security_group_ids = [dependency.vpc.outputs.default_security_group_id]
  container_definitions = <<DEFINITION
  [{
    "name": "client",
    "image": "public.ecr.aws/n6z6p5x6/kostas-test/client:latest",
    "essential": true,
    "requiresCompatibilities": [ 
      "FARGATE" 
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
          "awslogs-group": "/ecs/dev/",
          "awslogs-region": "eu-west-1",
          "awslogs-stream-prefix": "ecs"
      }
    },
    "portMappings": [
      {
        "containerPort": 80
      }
    ],
      "cpu": 256,
      "family": "fargate-task-definition",
      "memory": 512
  },
  {
    "name": "server",
    "image": "public.ecr.aws/n6z6p5x6/kostas-test/server:latest",
    "essential": true,
    "requiresCompatibilities": [ 
      "FARGATE" 
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
          "awslogs-group": "/ecs/dev/",
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
    "environment": [
        {
            "name": "TYPEORM_HOST",
            "value": "${dependency.postgres.outputs.db_instance_address}"
        },
        {
            "name": "TYPEORM_PASSWORD",
            "value": "${dependency.postgres_password.outputs.password}"
        },
        {
            "name": "TYPEORM_USERNAME",
            "value": "${dependency.postgres.outputs.db_instance_username}"
        },
        {
            "name": "REDIS_HOST",
            "value": "${dependency.redis.outputs.endpoint}"
        },
        {
            "name": "REDIS_PASSWORD",
            "value": "redispass"
        }
    ],
    "cpu": 256,
    "family": "fargate-task-definition",
    "memory": 512
  }
  ]
  DEFINITION
  tasks_desired_count   = 1
  kms_key_id            = dependency.kms.outputs.aws_kms_key_arn
  associate_alb         = true
  alb_security_group    = dependency.alb_sg.outputs.security_group_id
  environment           = "dev"
  fargate_task_cpu      = 512
  fargate_task_memory   = 1024
  logs_cloudwatch_group = "/ecs/dev/"
  target_container_name = "client"
  lb_target_groups = [
    {
      container_port              = 80
      container_health_check_port = 80
      lb_target_group_arn         = dependency.alb.outputs.target_group_arns[0]
    }
  ]
}
