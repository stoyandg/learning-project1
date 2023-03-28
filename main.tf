provider "aws" {
  region = var.region
}

terraform {
  required_providers {
    grafana = {
      source  = "grafana/grafana"
      version = "1.36.1"
    }
  }
}
module "networking" {
  source = "./modules/networking"

  app-name                = var.app-name
  id_of_vpc               = module.networking.id_of_vpc
  both_private_subnets_id = [module.networking.both_private_subnets_id]
}

module "sg" {
  source = "./modules/sg"

  app-name                          = var.app-name
  id_of_vpc                         = module.networking.id_of_vpc
  vpc_public_security_group_ids     = [module.sg.vpc_public_security_group_ids]
  vpc_prometheus_security_group_ids = [module.sg.vpc_prometheus_security_group_ids]
  vpc_private_security_group_ids    = [module.sg.vpc_private_security_group_ids]
}

module "db" {
  source = "./modules/db"

  app-name                   = var.app-name
  id_of_vpc                  = module.networking.id_of_vpc
  vpc_rds_security_group_ids = [module.sg.vpc_rds_security_group_ids]
  both_db_subnets_name       = module.networking.both_db_subnets_name
  master_password            = var.master_password
  depends_on                 = [module.networking.db_subnets]
}

module "apache" {
  source = "./modules/apache"

  app-name                       = var.app-name
  id_of_vpc                      = module.networking.id_of_vpc
  both_private_subnets_id        = module.networking.both_private_subnets_id
  both_public_subnets_id         = module.networking.both_public_subnets_id
  vpc_private_security_group_ids = [module.sg.vpc_private_security_group_ids]
  vpc_public_security_group_ids  = [module.sg.vpc_public_security_group_ids]

  depends_on = [module.db.db_instance]
}

module "bastion" {
  source = "./modules/bastion"

  app-name                      = var.app-name
  id_of_vpc                     = module.networking.id_of_vpc
  both_public_subnets_id        = module.networking.both_public_subnets_id
  vpc_public_security_group_ids = [module.sg.vpc_public_security_group_ids]

  depends_on = [module.apache.apache-autoscaling]
}

module "prometheus" {
  source = "./modules/prometheus"

  app-name                          = var.app-name
  id_of_vpc                         = module.networking.id_of_vpc
  both_public_subnets_id            = module.networking.both_public_subnets_id
  vpc_prometheus_security_group_ids = [module.sg.vpc_prometheus_security_group_ids]
}

module "grafana" {
  source = "./modules/grafana"

  prometheus_public_ip           = module.prometheus.prometheus_public_ip
  app-name                       = var.app-name
  id_of_vpc                      = module.networking.id_of_vpc
  both_public_subnets_id         = module.networking.both_public_subnets_id
  vpc_grafana_security_group_ids = [module.sg.vpc_grafana_security_group_ids]
}