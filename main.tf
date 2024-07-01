module "vpc" {
  source = "./modules/vpc"
  vpc_cidr = var.vpc_cidr
  env = var.env
  public_subent  = var.public_subent
  private_subent = var.private_subent
  azs = var.azs
 default_vpc_id = var.default_vpc_id
 account_no =  var.account_no
}
