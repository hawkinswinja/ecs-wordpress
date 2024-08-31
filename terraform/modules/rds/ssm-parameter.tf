resource "aws_ssm_parameter" "ssm-key" {
  for_each = tomap({
    "/wordpress/WORDPRESS_DB_HOST"     = aws_rds_cluster_instance.default.endpoint
    "/wordpress/WORDPRESS_DB_USER"     = var.db_username
    "/wordpress/WORDPRESS_DB_PASSWORD" = var.db_password
    "/wordpress/WORDPRESS_DB_NAME"     = var.db_name
  })

  name   = each.key
  type   = "SecureString"
  value  = each.value
  key_id = var.kms_key_id
}