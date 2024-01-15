


resource "aws_launch_template" "Hammad-ECS-Template" {
  name = "Hammad-ECS-Template" 
  image_id = var.ec2_ami
  instance_type = var.ec2_type
  key_name = var.key_name
  iam_instance_profile {
    name = "ecsInstanceRole"
  }
   user_data = base64encode("#!/bin/bash\necho ECS_CLUSTER=nginx >> /etc/ecs/ecs.config;")
  network_interfaces {
    associate_public_ip_address = true
    delete_on_termination      = true
    security_groups            = [var.alb_sg_id]
  }
}


resource "aws_autoscaling_group" "asg" {
    name                      = "Hammad-ASG"
    vpc_zone_identifier  = var.public_subnet_ids
    launch_template {
        id      = aws_launch_template.Hammad-ECS-Template.id
        version = "$Latest"
    }
    desired_capacity          = 1
    min_size                  = 1
    max_size                  = 2
    health_check_type    = "EC2"
    health_check_grace_period = 300
    target_group_arns = [var.alb_tg_arn]
}

# # resource "aws_autoscaling_policy" "target_tracking_policy" {
# #   name                   = "TargetTrackingPolicy"
# #   policy_type = "TargetTrackingScaling"
# #   estimated_instance_warmup = 300
# #   metric_aggregation_type = "Average"
  
# #   target_tracking_configuration {
# #     predefined_metric_specification {
# #       predefined_metric_type = "ASGAverageCPUUtilization"
# #     }
# #     target_value = 80.0
    
# #   }


# #   autoscaling_group_name = aws_autoscaling_group.asg.name
# # }