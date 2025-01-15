terraform {
  /*backend "s3" {
    bucket = var.s3_name
    key = "terrform.tfstate"
    region = var.region
  }*/
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.53"
    }

    github = {
      source = "integrations/github"
      version = ">=5.18.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.region
}