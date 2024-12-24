
variable "name" {
  description = "Name to use for the resources"
  type        = string
}

variable "private_subnet_cidrs" {
  description = "List of private subnet CIDR blocks"
  type        = list(string)
  default = ["10.0.3.0/24", "10.0.4.0/24" ]
}

variable "public_subnet_cidrs" {
  description = "List of public subnet CIDR blocks"
  type        = list(string)
}

variable "private_subnet_cidr_blocks" {
  description = "List of private subnet CIDR blocks"
  type        = list(string)
  default = ["10.0.3.0/24", "10.0.4.0/24" ]
}

variable "public_subnet_cidr_blocks" {
  description = "List of public subnet CIDR blocks"
  type        = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "vpc_id" {}
