variable "eks_cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID where the AWS Load Balancer Controller will operate"
  type        = string
}

variable "policy_file_path" {
  description = "Path to the IAM policy JSON file"
  type        = string
  default     = "./iam/AWSLoadBalancerController.json"
}

variable "cluster_region" {
  description = "The region where the EKS cluster is deployed"
  type        = string  
  
}

variable "enable_resource_tagging_nginx" {
  description = "Enable resource tagging"
  type        = bool
  default     = false  
}

variable "enable_resource_tagging_cert_manager" {
  description = "Enable resource tagging"
  type        = bool
  default     = false  
  
}
variable "enable_resource_tagging_alb" {
  description = "Enable resource tagging"
  type        = bool
  default     = false  
  
}