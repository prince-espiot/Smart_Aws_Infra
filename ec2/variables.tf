variable "ami_id" {}
variable "instance_type" {}
variable "tag_name" {}
variable "public_key" {
    type = string
    description = "DevOps Project Public key for EC2 instance"
    default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDb5+ZbTZC6Z5Ysp6U5g2y5jz2GK3jWHOAaCvYIi+FgE6mO5w2v828qBUTF3e6RcCKolD4NdgK2UQdH2bqNu0AJ3PvSM9jzbIJPZjdk5wNTrjlg5EADfm7Oc+ucnvJy1/oLMgpFpJaN5oozgLNnTmlD0zceXAigFuqWyPuEp2inprCe3EAZvsoJ9trjm9UruiKN+YKDNrCCBYSmCh71QwlaW0hIGad7v9t91e+lM1GYlol723vIqkv6Hemf6T4B8apGzAk4sVPA41hLnSEI4jfiTKaJ0nTkL3r55Xen+udiyTx/awqZYYsnUIDoSjbK2SxjIf/D5cBIVZ/5W4LzXRhf admin@DESKTOP-7847I2M"
}
variable "subnet_id" {}
variable "sg_enable_ssh_https" {}
variable "enable_public_ip_address" {}
variable "user_data_install_apache" {}
#variable "ec2_sg_name_for_python_api" {}
