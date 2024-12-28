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
  vpc_id                     = module.networking.vpc_id #check if you need to add id
  public_subnet_cidr_block   = tolist(module.networking.public_subnet_cidr_block)
}

module "ec2" {
  source                   = "./ec2"
  ami_id                   = var.ec2_ami_id
  instance_type            = var.ec2_instance_type #use the instance type that suits your needs
  tag_name                 = "Ubuntu Linux EC2"
  subnet_id                = tolist(module.networking.public_subnets)[0]
  sg_enable_ssh_https      = module.security_group.sg_ec2_sg_ssh_http_id
  enable_public_ip_address = true
  user_data_install_apache = templatefile("./template/ec2_install_apache.sh", {})
}

/*
module "s3_backend" {
  source = "./s3" 
  name   = var.s3_name  #name must be unique and small letters
}

module "eks" {
  source             = "./eks"
  cluster_name       = var.eks_cluster_name
  node_group_name    = var.node_group_name
  node_instance_type = var.node_instance_type # use the instance type that suits your needs
  desired_capacity   = 2
  min_size           = 1
  max_size           = 3
  vpc_id             = module.networking.vpc_id
  subnet_ids         =module.networking.public_subnets
  private_subnet_cidrs = module.networking.private_subnet_cidr_block
  public_subnet_cidrs = module.networking.public_subnet_cidr_block
}

module "db_module" {
  source              = "./db-mod"
  name                = "smart-db"
  vpc_id              = module.networking.vpc_id
  private_subnet_cidrs = module.networking.private_subnets
  public_subnet_cidrs  = module.networking.public_subnets
}

module "Devops_tools" {
  source = "./observability_n_gitops"
  eks_cluster_name = module.eks.cluster_name

}

# Only implement this module if you have applied the previous modules.
module "aws_lbc" {
  source            = "./load-balancer"
  eks_cluster_name  = module.eks.cluster_name
  cluster_region = "eu-north-1"
  vpc_id            = module.networking.vpc_id
  policy_file_path  = "./iam/AWSLoadBalancerController.json"

}
*/

