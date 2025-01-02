output "ssh_connection_string_for_ec2" {
  value = format("%s%s", "ssh -i /home/ubuntu/keys/aws_ec2_terraform ubuntu@", aws_spot_instance_request.ec2.public_ip)
}

output "dev_proj_1_ec2_instance_id" {
  value = aws_spot_instance_request.ec2.id
}
output "public_ip" {
  value       = aws_spot_instance_request.ec2.public_ip
  description = "The public IP address of the EC2 instance."
}
