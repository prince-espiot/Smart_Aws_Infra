variable "ecr_repo_name" {
  description = "The name of the service"
  type        = string
  
}

variable "enable_ecr" {
  description = "Enable ECR"
  type        = bool
  default     = false   
  
}