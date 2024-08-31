# Create SSM encrypted data for wordpress environment variables
resource "aws_ssm_parameter" "ssm-key" {
  for_each = tomap({
    "/wordpress/WORDPRESS_DB_HOST"     = aws_rds_cluster.aurora.endpoint
    "/wordpress/WORDPRESS_DB_USER"     = var.db_username
    "/wordpress/WORDPRESS_DB_PASSWORD" = var.db_password
    "/wordpress/WORDPRESS_DB_NAME"     = var.db_name
  })

  name   = each.key
  type   = "SecureString"
  value  = each.value
  key_id = var.kms_key_id

}

resource "aws_rds_cluster" "aurora" {
  cluster_identifier      = "aurora-cluster"
  engine                  = "aurora-mysql"
  engine_mode             = "provisioned"
  engine_version          = "8.0.mysql_aurora.3.05.2"
  master_username         = var.db_username
  master_password         = var.db_password
  database_name           = var.db_name
  kms_key_id              = var.kms_key_id
  backup_retention_period = 1
  preferred_backup_window = "07:00-09:00"
  db_subnet_group_name    = aws_db_subnet_group.db.name
  vpc_security_group_ids  = var.rds-security-group
  storage_encrypted       = true
  skip_final_snapshot     = true

  serverlessv2_scaling_configuration {
    max_capacity = 2
    min_capacity = 1
  }
}

resource "aws_rds_cluster_instance" "aurora_instance" {
  cluster_identifier  = aws_rds_cluster.aurora.id
  instance_class      = "db.serverless"
  engine              = aws_rds_cluster.aurora.engine
  engine_version      = aws_rds_cluster.aurora.engine_version
  publicly_accessible = false
}

resource "aws_db_subnet_group" "db" {
  name       = "${var.name}-db-subnet-group"
  subnet_ids = var.db_subnets
}