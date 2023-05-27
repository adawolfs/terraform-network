provider "google" {
  credentials = file("${var.credentials_file}")
  project     = var.project_id
  region      = var.region
  zone        = var.zone
}

module "ssh" {
  source = "./modules/ssh/"
}

module "vpc" {
  source = "./modules/vpc/"

}

module "vpn" {
  source            = "./modules/vpn/"
  vpc_vpn_network   = module.vpc.vpn_network
  vpc_vpn_subnet    = module.vpc.vpn_subnet
  vpc_intra_network = module.vpc.intra_network
  vpc_intra_subnet  = module.vpc.intra_subnet
  vpc_dmz_network   = module.vpc.dmz_network
  vpc_dmz_subnet    = module.vpc.dmz_subnet
  ssh_posix_user    = var.ssh_posix_user
}

module "http" {
  source          = "./modules/http/"
  vpc_dmz_network = module.vpc.dmz_network
  vpc_dmz_subnet  = module.vpc.dmz_subnet
  ssh_posix_user  = var.ssh_posix_user

}

module "domain" {
  source            = "./modules/domain/"
  vpc_intra_network = module.vpc.intra_network
  vpc_intra_subnet  = module.vpc.intra_subnet
  ssh_posix_user    = var.ssh_posix_user
}

module "dns" {
  source = "./modules/dns/"
}

module "bastion" {
  source = "./modules/bastion/"
}

module "ips" {
  source = "./modules/ips/"
}
