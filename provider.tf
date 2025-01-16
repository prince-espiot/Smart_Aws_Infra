terraform {
  /*backend "s3" {
    bucket         = var.s3_name
    key            = "prince/s3/terrform.tfstate"
    region         = var.region
    dynamodb_table = "terraform-locks"
  }*/
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.53"
    }

    github = {
      source  = "integrations/github"
      version = ">=5.18.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.region
}