
resource "aws_lb" "ecs_lb" {
  name               = "Hammad-ECS-ALB"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.public_subnet_ids
  security_groups    = [var.alb_sg_id]
}

resource "aws_lb_target_group" "ecs_target_group" {
  name     = "Hammad-ECS-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "instance"

  health_check {
  healthy_threshold   = "3"
  interval            = "300"
  protocol            = "HTTP"
  matcher             = "200"
  timeout             = "3"
  path                = "/"
  unhealthy_threshold = "2"
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.ecs_lb.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_target_group.id
  }
}
