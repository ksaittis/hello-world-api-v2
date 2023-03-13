module "ecs_cluster" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-ecs.git//.?ref=v4.1.2"
  cluster_name = "${var.project_name}-${var.deployment_name}"

  cluster_configuration = {
    execute_command_configuration = {
      logging = "OVERRIDE"
      log_configuration = {
        cloud_watch_log_group_name = "/aws/ecs/${var.project_name}/${var.deployment_name}"
      }
    }
  }
}
