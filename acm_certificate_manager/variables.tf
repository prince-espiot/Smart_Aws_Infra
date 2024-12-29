variable "domain_name" {
    type = string
    description = "Name of the domain"
}
variable "hosted_zone_id" {
    type = string
    description = "Hosted Zone ID"
}

data "aws_route53_zone" "selected" {
  name = var.domain_name
}