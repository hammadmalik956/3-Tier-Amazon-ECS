output app_asg_policy_arn {
    value = aws_appautoscaling_policy.ecs_service_scaling_policy.arn
}