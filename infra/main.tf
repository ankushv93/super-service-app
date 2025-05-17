module "networking" {
  source = "./modules/networking"
  vpc_cidr = var.vpc_cidr
  no_of_public_subnet = var.no_of_public_subnet
  no_of_private_subnet = var.no_of_private_subnet
}
