
variable "db_password" {
  description = "Password for the database"
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "Name for the database"
  type        = string
}

variable "db_username" {
  description = "Username for the database"
  type        = string
}

variable "kms_key_id" {
  description = "KMS key id for the SSM parameter"
  type        = string
  sensitive   = true
}

variable "db_subnets" {
  description = "Subnets for the RDS instance"
  type        = list(string)
}

variable "name" {
  description = "Name for the RDS instance"
  type        = string
}

variable "rds-security-group" {
  description = "Security group ID for the RDS instance"
  type        = list(string)

}