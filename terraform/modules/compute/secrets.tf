resource "aws_ssm_parameter" "db_password" {
  name        = "/${var.env_name}/app/db_password"
  description = "Database password for application"
  type        = "SecureString"
  value       = var.db_password
}