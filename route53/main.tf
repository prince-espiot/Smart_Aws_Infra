# Retrieve information about the ALB
data "aws_lb" "my_lb" {
  name = var.aws_lb_dns_name
}

# Retrieve the Route 53 hosted zone
data "aws_route53_zone" "princeokumo_com" {
  name         = var.domain_name
  private_zone = false
}

# Create an A record for the load balancer
resource "aws_route53_record" "lb_record" {
  zone_id = data.aws_route53_zone.princeokumo_com.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = data.aws_lb.my_lb.dns_name
    zone_id                = data.aws_lb.my_lb.zone_id
    evaluate_target_health = true
  }
}

# Create a CNAME record for the load balancer
resource "aws_route53_record" "web_record" {
  zone_id = data.aws_route53_zone.princeokumo_com.zone_id
  name    = "www.${var.domain_name}"
  type    = "CNAME"

  ttl     = 300
  records = [data.aws_lb.my_lb.dns_name]
}

