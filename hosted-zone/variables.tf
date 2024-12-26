variable "domain_name" {
  type = string
  description = "Name of the domain"
}

variable "aws_lb_dns_name" {
  type = string
  description = "DNS name of the load balancer"
}

variable "aws_lb_zone_id" {
  type = string
  description = "Zone ID of the load balancer"
}