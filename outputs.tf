/*output "backend_bucket_name" {
  value = module.s3_backend.bucket_name
}

output "backend_kms_key_arn" {
  value = module.s3_backend.kms_key_arn
}*/
output "Bastion_ip" {
  value = module.ec2.public_ip
}

/*output "rds_hostname" {
  description = "RDS instance hostname"
  value       = module.db_module.rds_hostname
  sensitive   = false
}

output "rds_port" {
  description = "RDS instance port"
  value       = module.db_module.rds_port
  sensitive   = false
}

output "rds_username" {
  description = "RDS instance root username"
  value       = module.db_module.rds_username
  sensitive   = false
}

output "rds_password" {
  description = "database password"
  value = module.db_module.db_password
  sensitive = true
}

output "acm_certificate_arn" {
  value = module.acm.acm_certificate_arn  
}*/