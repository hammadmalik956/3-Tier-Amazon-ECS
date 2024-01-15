output alb_tg_arn {
    value = aws_lb_target_group.ecs_target_group.arn
}
output alb_listner {
    value = aws_lb_listener.listener
}