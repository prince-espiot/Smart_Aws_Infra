resource "aws_s3_bucket" "shared_backend_bucket" {
  bucket = var.name

  tags = {
    Name        = "tf-bucket"
    Environment = var.name
  }
}

resource "aws_kms_key" "s3sharedkey" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = var.kms_deletion_window_days
}

resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = aws_s3_bucket.shared_backend_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.s3sharedkey.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_versioning" "versioning_bucket_enabled" {
  bucket = aws_s3_bucket.shared_backend_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = aws_s3_bucket.shared_backend_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
