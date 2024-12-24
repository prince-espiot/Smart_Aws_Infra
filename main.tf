
module "networking" {
  source               = "./networking"
  vpc_cidr             = var.vpc_cidr
  vpc_name             = var.vpc_name
  cidr_public_subnet   = var.cidr_public_subnet
  eu_availability_zone = var.eu_availability_zone
  cidr_private_subnet  = var.cidr_private_subnet
}

module "security_group" {
  source                     = "./security-groups"
  ec2_sg_name                = "SG for EC2 to enable SSH(22) and HTTP(80)"
  vpc_id                     = module.networking.dev_proj_1_vpc_id #check if you need to add id
  public_subnet_cidr_block   = tolist(module.networking.public_subnet_cidr_block)
}

module "s3_backend" {
  source = "./s3_backend" # Path to your module folder
  name   = "my-environment"
}

module "ec2" {
  source                   = "./ec2"
  ami_id                   = var.ec2_ami_id
  instance_type            = "t3.micro"
  tag_name                 = "Ubuntu Linux EC2"
  public_key               = var.public_key
  subnet_id                = tolist(module.networking.dev_proj_1_public_subnets)[0]
  sg_enable_ssh_https      = module.security_group.sg_ec2_sg_ssh_http_id
  enable_public_ip_address = true
  user_data_install_apache = templatefile("./template/ec2_install_apache.sh", {})
}

module "eks" {
  source             = "./eks"
  cluster_name       = "Smartbi-cluster"
  node_group_name    = "eks-node-group"
  node_instance_type = "t3.medium"
  desired_capacity   = 2
  min_size           = 1
  max_size           = 3
  vpc_id             = module.networking.dev_proj_1_vpc_id
  subnet_ids         = module.networking.dev_proj_1_public_subnets
  security_group_ids = [module.security_group.sg_ec2_sg_ssh_http_id]
  private_subnet_cidrs = tolist(module.networking.private_subnet_cidrs_block)
  public_subnet_cidrs = tolist(module.networking.public_subnet_cidr_block)

}

module "db_module" {
  source              = "./db-mod"
  name                = "my-app-db"
  private_subnet_cidrs = tolist(module.networking.private_subnet_cidrs_block)
  public_subnet_cidrs = tolist(module.networking.public_subnet_cidr_block)
}

module "hosted_zone" {
  source          = "./hosted-zone"
  domain_name     = var.domain_name
  aws_lb_dns_name = module.alb.aws_lb_dns_name
  aws_lb_zone_id  = module.alb.aws_lb_zone_id
}
