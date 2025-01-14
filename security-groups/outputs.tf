output "sg_ec2_sg_ssh_http_id" {
  value = aws_security_group.ec2_sg_ssh.id
}

output "sg_ec2_sg_http_id" {
  value = aws_security_group.enable_ec2_sg_http.id
  
}