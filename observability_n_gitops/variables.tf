variable "eks_cluster_name" {
    description = "The name of the EKS cluster"
    type        = string
}

variable "enable_argo_cd" {
    description = "Enable Argo CD"
    type        = bool  
  
}

variable "enable_argo_cd_image_updater" {
    description = "Enable Argo CD Image Updater"
    type        = bool
  
}