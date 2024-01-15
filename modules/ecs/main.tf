

resource "aws_ecs_cluster" "my_ecs_cluster" {
    name  = var.cluster_name
}

resource "aws_ecs_capacity_provider" "ec2_capacity_provider" {
  name = "EC2CapacityProviders"
  auto_scaling_group_provider {
    auto_scaling_group_arn = var.asg_arn
    managed_scaling {
      status         = "ENABLED"
      target_capacity = 80
      
      
    }
    
    managed_termination_protection = "DISABLED"
  }
}

resource "aws_ecs_cluster_capacity_providers" "cluster_capacity_provider" {
  cluster_name           = aws_ecs_cluster.my_ecs_cluster.name
  capacity_providers     = [aws_ecs_capacity_provider.ec2_capacity_provider.name,""]
  default_capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.ec2_capacity_provider.name
    base             = 0
    weight           = 1
  }
}




resource "aws_ecs_service" "ecs_service" {
  name            = "nginx"
  cluster         = aws_ecs_cluster.my_ecs_cluster.id
  task_definition = var.task_def_arn
  scheduling_strategy  = "REPLICA"
  desired_count   = 0
  force_new_deployment = true

  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200
  
  

  capacity_provider_strategy {
   capacity_provider = aws_ecs_capacity_provider.ec2_capacity_provider.name
   weight            = 1
 }



  load_balancer {
    target_group_arn = var.alb_tg_arn
    container_name   = "nginx"
    container_port   = 80
  }

  depends_on = [var.alb_listner]
}
resource "aws_appautoscaling_target" "ecs_service_scaling_target" {
  max_capacity       = 4  # Maximum desired count for tasks
  min_capacity       = 0  # Minimum desired count for tasks
  resource_id        = "service/nginx/nginx"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
  depends_on = [aws_ecs_service.ecs_service]
}
resource "aws_appautoscaling_policy" "ecs_service_scaling_policy" {
  name                   = "scale_up_tasks"
  resource_id            = aws_appautoscaling_target.ecs_service_scaling_target.resource_id
  service_namespace      = aws_appautoscaling_target.ecs_service_scaling_target.service_namespace
  scalable_dimension     = aws_appautoscaling_target.ecs_service_scaling_target.scalable_dimension
  policy_type            = "StepScaling"
  
  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 300  # 5 minutes cooldown period
    metric_aggregation_type = "Average"
    
    step_adjustment {
      scaling_adjustment = 1  # Increase desired count by 1
      metric_interval_lower_bound = 0
      metric_interval_upper_bound = 50
    }
    
    step_adjustment {
      scaling_adjustment = 1  # Increase desired count by 1
      metric_interval_lower_bound = 50
      metric_interval_upper_bound = 65
    }

    step_adjustment {
      scaling_adjustment = 1  # Increase desired count by 1
      metric_interval_lower_bound = 65
      metric_interval_upper_bound = 75
    }

    step_adjustment {
      scaling_adjustment = 1  # Increase desired count by 1
      metric_interval_lower_bound = 75
      # No upper bound for the last interval
    }
  }
}