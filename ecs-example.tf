
/* services = [
  {
    service_name      = "worker"
    containerPort     = 7002
    fargate_cpu       = 1024
    fargate_memory    = 2048
    min_capacity      = 2
    max_capacity      = 4
    grace_period      = null    
  }
] */

module "cloudwatch_services" {
  count        = length(var.services)
  source       = "../modules/logs"
  project_name = "${local.fullname}-${lookup(var.services[count.index], "service_name")}"
}

module "other_services" {
  source        = "../modules/ecs-repo-vars-efs"
  count         = length(var.services)
  createCluster = false

  project_name                      = "${local.fullname}-${lookup(var.services[count.index], "service_name")}"
  cluster_id                        = module.ecs.ECS_ClusterId
  app_image                         = var.app_image
  containerPort                     = lookup(var.services[count.index], "containerPort", "8080")
  fargate_cpu                       = lookup(var.services[count.index], "fargate_cpu")
  fargate_memory                    = lookup(var.services[count.index], "fargate_memory")
  aws_region                        = var.aws_region
  ecs_task_execution_role_name      = "${local.fullname}-${lookup(var.services[count.index], "service_name")}-EcsTaskExecutionRole"
  app_count                         = lookup(var.services[count.index], "app_count", 1)
  security_groups                   = [module.loadbalancer.security_groups_lb, aws_security_group.ecs_tasks.id]
  subnets                           = var.private_subnets_ids
  assign_public_ip                  = false
  alb_target_group                  = null
  health_check_grace_period_seconds = lookup(var.services[count.index], "grace_period", 10)
}

module "auto_scaling_services" {
  count                   = length(var.services)
  source                  = "../modules/asg"
  resource_id             = "service/${module.ecs.ECS_ClusterName}/${module.other_services[count.index].ECS_ServiceName}"
  min_capacity            = lookup(var.services[count.index], "min_capacity")
  max_capacity            = lookup(var.services[count.index], "max_capacity")
  project_name            = "${local.fullname}-${lookup(var.services[count.index], "service_name")}"
  ECS_ClusterName         = module.ecs.ECS_ClusterName
  ECS_ServiceName         = module.other_services[count.index].ECS_ServiceName
  evaluation_periods_down = "60"
  evaluation_periods_up   = "1"
}

output "SERVICES" {
  value = {
    CLUSTER_NAME   = module.ecs.ECS_ClusterName
    ECS_SERVICE    = module.other_services.*.ECS_ServiceName
    TASK_FAMILY    = module.other_services.*.family
    AWS_LOGS_GROUP = module.cloudwatch_services.*.logs_groups
    EXEC_ARN_ROLE  = module.other_services.*.execution_rol_arn
    REGION         = var.aws_region
  }
}
