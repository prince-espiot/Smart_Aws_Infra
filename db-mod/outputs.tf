output "db_instance_identifier" {
  description = "Identifier of the DB instance"
  value       = aws_db_instance.db.id
}

output "db_endpoint" {
  description = "Endpoint of the DB instance"
  value       = aws_db_instance.db.endpoint
}

output "rds_hostname" {
  description = "RDS instance hostname"
  value       = aws_db_instance.db.address
  sensitive   = true
}

output "rds_port" {
  description = "RDS instance port"
  value       = aws_db_instance.db.port
  sensitive   = true
}

output "rds_username" {
  description = "RDS instance root username"
  value       = aws_db_instance.db.username
  sensitive   = true
}

output "db_password" {
  description = "Generated DB root password"
  value       = random_password.root_password.result
  sensitive   = true
}
