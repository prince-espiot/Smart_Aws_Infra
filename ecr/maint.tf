resource "aws_ecr_repository" "ecr_service_myapp" {
  count = var.enable_ecr == true ? 1 : 0
  name = var.ecr_repo_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
        scan_on_push = true
    }
  tags = {
    Name = var.ecr_repo_name
  }
  
}

