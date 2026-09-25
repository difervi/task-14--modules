provider "aws" {
  region = var.aws_region
}

locals {
  vpc_name             = "${var.name_prefix}-vpc"
  igw_name             = "${var.name_prefix}-igw"
  route_table_name     = "${var.name_prefix}-rt"
  ssh_sg_name          = "${var.name_prefix}-ssh-sg"
  public_http_sg_name  = "${var.name_prefix}-public-http-sg"
  private_http_sg_name = "${var.name_prefix}-private-http-sg"
  launch_template_name = "${var.name_prefix}-template"
  asg_name             = "${var.name_prefix}-asg"
  lb_name              = "${var.name_prefix}-lb"
  target_group_name    = "${var.name_prefix}-tg"

  public_subnets = {
    for key, subnet in var.public_subnets : key => {
      name              = "${var.name_prefix}-subnet-public-${key}"
      cidr_block        = subnet.cidr_block
      availability_zone = subnet.availability_zone
    }
  }
}

module "network" {
  source = "./modules/network"

  vpc_name         = local.vpc_name
  vpc_cidr_block   = var.vpc_cidr_block
  public_subnets   = local.public_subnets
  igw_name         = local.igw_name
  route_table_name = local.route_table_name
}

module "network_security" {
  source = "./modules/network_security"

  vpc_id               = module.network.vpc_id
  allowed_ip_range     = var.allowed_ip_range
  ssh_sg_name          = local.ssh_sg_name
  public_http_sg_name  = local.public_http_sg_name
  private_http_sg_name = local.private_http_sg_name
}

module "application" {
  source = "./modules/application"

  vpc_id     = module.network.vpc_id
  subnet_ids = module.network.public_subnet_ids
  instance_security_group_ids = [
    module.network_security.ssh_sg_id,
    module.network_security.private_http_sg_id,
  ]
  lb_security_group_ids = [module.network_security.public_http_sg_id]
  instance_type         = var.instance_type
  launch_template_name  = local.launch_template_name
  asg_name              = local.asg_name
  asg_desired_capacity  = var.asg_desired_capacity
  asg_min_size          = var.asg_min_size
  asg_max_size          = var.asg_max_size
  lb_name               = local.lb_name
  target_group_name     = local.target_group_name
}
