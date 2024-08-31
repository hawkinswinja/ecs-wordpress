variable "repo-name" {
  description = "Name for the ECR repository"
  type        = string
}

variable "name" {
  description = "Name for the ECS cluster"
  type        = string
}

variable "ecs_subnets" {
  description = "Subnet IDs for the ECS cluster. Preferably private subnets."
  type        = list(string)
}

variable "ecs_instance_type" {
  description = "Instance type for the ECS cluster"
  type        = string
}
variable "ecs_security_groups" {
  description = "Security group IDs for the ECS cluster"
  type        = list(string)
}

variable "image_tag" {
  description = "Tag for the ECR repository"
  type        = string
}

variable "log_region" {
  description = "AWS region for logs. Set same as ECS region"
  type        = string
}

variable "container_port" {
  description = "Port on which the container listens"
  type        = number
}

variable "efs_security_group_ids" {
  description = "Security group ID for the EFS access point"
  type        = list(string)
}

variable "alb_security_group" {
  description = "Security group IDs for the ALB"
  type        = list(string)
}

variable "alb_subnets" {
  description = "Subnet IDs for the ALB"
  type        = list(string)
}

variable "certificate_arn" {
  description = "ARN for the SSL certificate"
  type        = string
}

variable "ssm-key" {
  description = "SSM key from the rds module"
}

variable "vpc_id" {
  description = "VPC ID for the ECS cluster"
  type        = string
}

variable "ssh_key_name" {
  description = "SSH key name for the ECS instances. Used for debugging"
  type        = string
}

variable "container_path" {
  description = "Path for the container"
  type        = string
}

variable "efs_directory" {
  description = "Directory for the EFS access point"
  type        = string
  
}