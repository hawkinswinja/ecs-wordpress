module "vpc" {
  source   = "./modules/vpc"
  vpc_name = var.vpc_name
}

module "rds" {
  source      = "./modules/rds"
  db_password = var.db_password
  db_username = var.db_username
  db_name     = var.db_name
  kms_key_id  = var.kms_key_id
  rds-security-group = [module.vpc.rds_sg]
  db_subnets  = module.vpc.ecs-private-subnet
  name        = var.vpc_name
}

module "ecs" {
  source      = "./modules/ecs"
  name        = var.vpc_name
  vpc_id      = module.vpc.vpc_id
  ecs_subnets = module.vpc.ecs-private-subnet
  ssm-key = module.rds.ssm_key
  alb_subnets = module.vpc.alb-subnet
  alb_security_group = [module.vpc.public_sg]
  ecs_security_groups = [module.vpc.private_sg]
  efs_security_group_ids = [module.vpc.efs_sg]
  image_tag   = var.image_tag
  repo-name   = var.repo-name
  certificate_arn = var.certificate_arn
  log_region = var.region
  container_path = var.container_path
  container_port = var.container_port
  ecs_instance_type = var.ecs_instance_type
  ssh_key_name = var.ssh_key_name
  efs_directory = var.efs_direrctory
}

output "ecr_repo_url" {
  value = module.ecs.ecr_repo_url
}

output "alb_dns_name" {
  value = module.ecs.alb_dns_name
}