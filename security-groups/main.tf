
resource "aws_security_group" "ec2_sg_ssh" {
  name        = var.ec2_sg_name
  description = "Enable the Port 22(SSH)"
  vpc_id      = var.vpc_id

  # ssh for terraform remote exec
  ingress {
    description = "Allow remote SSH from anywhere"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }

  
  #Outgoing request
  egress {
    description = "Allow outgoing request"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Security Groups to allow SSH(22)"
  }
}

resource "aws_security_group" "enable_ec2_sg_http" {
  count = var.enable_http ? 1 : 0
  name        = var.ec2_sg_name
  description = "Enable the Port 80(http)"
  vpc_id      = var.vpc_id

# enable http
  ingress {
    description = "Allow HTTP request from anywhere"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }
  

  #Outgoing request
  egress {
    description = "Allow outgoing request"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
}
 tags = {
      Name = "Security Groups to allow HTTP(80)"
    }	
}