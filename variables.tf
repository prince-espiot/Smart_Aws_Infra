/*variable "bucket_name" {
  type        = string
  description = "Remote state bucket name"
}
*/

variable "name" {
  type        = string
  description = "Tag name"
}

variable "environment" {
  type        = string
  description = "Environment name"
}

variable "vpc_cidr" {
  type        = string
  description = "Public Subnet CIDR values"
}

variable "vpc_name" {
  type        = string
  description = "DevOps Project 1 VPC 1"
}

variable "cidr_public_subnet" {
  type        = list(string)
  description = "Public Subnet CIDR values"
}

variable "cidr_private_subnet" {
  type        = list(string)
  description = "Private Subnet CIDR values"
}

variable "eu_availability_zone" {
  type        = list(string)
  description = "Availability Zones"
}

variable "domain_name" {
  type = string
  description = "Name of the domain"
}

variable "ec2_ami_id" {
  type        = string
  description = "DevOps Project AMI Id for EC2 instance"
}

variable "ec2_user_data_install_apache" {
  type = string
  description = "Script for installing the Apache2"
}


variable "node_group_name" {
  type = string
  default = "eks-node-group"
  description = "node group name"
}

variable "eks_cluster_name" {
  type = string
  default = "eks_cluster_name"
  description = "eks cluster name"  
  
}

variable "node_instance_type" {
  type = string
  default = "t3.medium"
  description = "node instance type"
}

variable "ec2_instance_type" {
  type = string
  default = "t3.micro"
  description = "ec2 instance type"
}

variable "s3_name" {
  type = string
  default = "s3_name"
  description = "smartbi" 
  
}

variable "region" {
  type = string
  description = "aws region"
}
