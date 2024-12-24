output "bucket_name" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.shared_backend_bucket.id
}

output "kms_key_arn" {
  description = "The ARN of the KMS key"
  value       = aws_kms_key.s3sharedkey.arn
}
