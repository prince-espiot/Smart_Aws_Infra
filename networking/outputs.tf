output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnets" {
  value = aws_subnet.public_subnets.*.id
}

output "private_subnets" {
  value = aws_subnet.private_subnets.*.id
}

output "public_subnet_cidr_block" {
  value = aws_subnet.public_subnets.*.cidr_block
}

output "private_subnet_cidr_block" {
  value = aws_subnet.private_subnets.*.cidr_block
}

output "public_subnet_cidr_id" {
  value = aws_subnet.public_subnets.*.id
}

output "private_subnet_cidrs_block" {
  value = aws_subnet.private_subnets.*.id
}


output "private_subnet_tags" {
  value = aws_subnet.private_subnets[*].tags
}
