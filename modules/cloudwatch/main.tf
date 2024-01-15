resource "aws_cloudwatch_metric_alarm" "ecs_service_scaling_alarm" {
  alarm_name          = "ecs-service-scaling-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"  # Adjust this based on your ECS service metrics
  namespace           = "AWS/ECS"
  period              = 60  # 1-minute period, adjust as needed
  statistic           = "Average"
  threshold           = 50  # Adjust the threshold based on your requirements
  actions_enabled     = true
  alarm_description   = "Alarm for scaling ECS service"

  dimensions = {
    ServiceName = "nginx",
    ClusterName = "nginx"  # Replace with your ECS cluster name
  }

  alarm_actions = [var.app_asg_policy_arn]
}
