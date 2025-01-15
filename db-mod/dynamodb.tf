# Create DynamoDB table for state locking
resource "aws_dynamodb_table" "terraform_locks" {
  count = var.enable_dynamodb_lock ? 1 : 0
  name         = "terraform-locks"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"  # String
  }

  hash_key = "LockID"

  tags = {
    Environment = "Production"
    Purpose     = "TerraformStateLocking"
  }
}