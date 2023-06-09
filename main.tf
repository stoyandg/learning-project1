module "networking" {
  source = "./modules/networking"

  app-name                = local.app-name
  id_of_vpc               = module.networking.id_of_vpc
  both_private_subnets_id = [module.networking.both_private_subnets_id]
}

module "db" {
  source                     = "modules/db"
  app-name                   = local.app-name
  id_of_vpc                  = module.networking.id_of_vpc
  vpc_rds_security_group_ids = [module.sg.vpc_rds_security_group_ids]
  both_db_subnets_name       = module.networking.both_db_subnets_name
  master_password            = local.master-password
  depends_on                 = [module.networking]
}

module "bastion" {
  source    = "modules/asg"
  name      = "bastion"
  image_id  = "ami-051270933c06fc174"
  key_name  = local.ssh_key_name
  user_data = "#!/bin/bash\nhostnamectl set-hostname bastion"

  enable_network_load_balancer = true
  loadbalancer_port            = 22
  health_check_port            = 22
  loadbalancer_subnet_ids      = [module.networking.both_public_subnets_id]
  autoscaling_group_subnet_ids = [module.networking.both_public_subnets_id]
  public_security_group_ids    = [module.sg.vpc_public_security_group_ids]
  vpc_id                       = module.networking.id_of_vpc
  depends_on                   = [module.apache]
}

module "apache" {
  source    = "modules/asg"
  name      = "apache"
  image_id  = "ami-0a8b8f320c122619d"
  key_name  = local.ssh_key_name
  user_data = "#!/bin/bash\nhostnamectl set-hostname apache"

  enable_application_load_balancer = true
  loadbalancer_port                = 80
  health_check_port                = 80
  loadbalancer_subnet_ids          = [module.networking.both_public_subnets_id]
  autoscaling_group_subnet_ids     = [module.networking.both_private_subnets_id]
  public_security_group_ids        = [module.sg.vpc_public_security_group_ids]
  vpc_id                           = module.networking.id_of_vpc
  depends_on                       = [module.db]
}


module "sg" {
  source = "./modules/sg"

  app-name                          = local.app-name
  id_of_vpc                         = module.networking.id_of_vpc
  vpc_public_security_group_ids     = [module.sg.vpc_public_security_group_ids]
  vpc_prometheus_security_group_ids = [module.sg.vpc_prometheus_security_group_ids]
  vpc_private_security_group_ids    = [module.sg.vpc_private_security_group_ids]
}

module "prometheus" {
  source = "./modules/prometheus"

  app-name                          = local.app-name
  id_of_vpc                         = module.networking.id_of_vpc
  both_public_subnets_id            = module.networking.both_public_subnets_id
  vpc_prometheus_security_group_ids = [module.sg.vpc_prometheus_security_group_ids]
}

module "grafana" {
  source = "./modules/grafana"

  prometheus_public_ip           = module.prometheus.prometheus_public_ip
  app-name                       = local.app-name
  id_of_vpc                      = module.networking.id_of_vpc
  both_public_subnets_id         = module.networking.both_public_subnets_id
  vpc_grafana_security_group_ids = [module.sg.vpc_grafana_security_group_ids]
}
