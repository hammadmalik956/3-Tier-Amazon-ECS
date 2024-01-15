output vpc_id {
  value       = aws_vpc.main.id
}
output alb_sg_id {
    value = aws_security_group.load_balancer_security_group.id
}
output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}