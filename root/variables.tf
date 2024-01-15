variable "vpc_region" {}
variable "ecs_sg" {}
variable "ec2_type" {}
variable "ec2_ami" {}
variable "iam_role_name" {}
variable key_name {}
variable "cluster_name" {
  description = "Name for the ECS cluster."
  type        = string
  default     = "nginx"
}
variable task_def_arn {}