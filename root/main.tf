
module "vpc" {
  source = "../modules/vpc"
}



module "alb" {
  source = "../modules/alb"
  alb_sg_id = module.vpc.alb_sg_id
  vpc_id = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
}

module "asg" {
  source = "../modules/asg"
  ec2_type = var.ec2_type
  ec2_ami = var.ec2_ami
  key_name = var.key_name
  alb_sg_id = module.vpc.alb_sg_id
  alb_tg_arn = module.alb.alb_tg_arn
  public_subnet_ids = module.vpc.public_subnet_ids
}

module "ecs" {
  source = "../modules/ecs"
  asg_arn = module.asg.asg_arn
  cluster_name = var.cluster_name
  alb_tg_arn = module.alb.alb_tg_arn
  alb_listner = module.alb.alb_listner
  task_def_arn = var.task_def_arn
  
}

module "cloudwatch" {
    source = "../modules/cloudwatch"
    app_asg_policy_arn = module.ecs.app_asg_policy_arn
}









