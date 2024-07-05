module "vpc" {
  source                     = "./modules/vpc"
  vpc_cidr                   = var.vpc_cidr
  env                        = var.env
  public_subnet              = var.public_subnet
  private_subnet             = var.private_subnet
  azs                        = var.azs
  default_vpc_id             = var.default_vpc_id
  account_no                 = var.account_no
  default_vpc_cidr           = var.default_vpc_cidr
  default_vpc_route_table_id = var.default_vpc_route_table_id
}

module "public_alb" {
  source        = "./modules/alb"
  env           = var.env
  alb_type      = "public"
  internal      = false
  vpc_id        = module.vpc.vpc_id
  allow_sg_cidr = "0.0.0.0/0"
  subnet        = module.vpc.public_subnet
}

module "private_alb" {
  source        = "./modules/alb"
  env           = var.env
  alb_type      = "private"
  internal      = true
  vpc_id        = module.vpc.vpc_id
  allow_sg_cidr = var.vpc_cidr
  subnet        = module.vpc.private_subnet
}

module "frontend" {
  source            = "./modules/app"
  app_port          = 80
  component         = "frontend"
  env               = var.env
  instance_type     = "t3.small"
  vpc_cidr          = var.vpc_cidr
  vpc_id            = module.vpc.vpc_id
  subnets           = module.vpc.private_subnet
  bastion_node_cidr = var.bastion_node_cidr
}
