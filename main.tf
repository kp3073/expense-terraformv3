module "vpc" {
  source = "./modules/vpc"
  vpc_cidr = var.vpc_cidr
  env = var.env
  public_subent = var.public_subnet
  private_subent = var.private_subnet
  azs = var.azs
}
