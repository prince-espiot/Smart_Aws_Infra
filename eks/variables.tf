# Variables
variable "cluster_name" {}
variable "node_group_name" {}
variable "node_instance_type" {}
variable "desired_capacity" {}
variable "min_size" {}
variable "max_size" {}
variable "vpc_id" {}
variable "subnet_ids" {
    type = list(string)
    default = ["10.0.3.0/24", "10.0.4.0/24"]

}
variable "private_subnet_cidrs" {}
variable "public_subnet_cidrs" {}
variable "region" {
  default = "eu-north-1"    
}