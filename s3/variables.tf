variable "name" {
  description = "The name prefix for the S3 bucket"
  type        = string
}

variable "kms_deletion_window_days" {
  description = "The number of days to retain the KMS key after deletion is requested"
  type        = number
  default     = 10
}
