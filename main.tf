data "aws_availability_zones" "available" {
  state = "available"
}

module "networking" {
  source = "./modules/networking"

  app_name             = local.app_name
  availability_zones   = slice(data.aws_availability_zones.available.names, 0, 3)
  cidr                 = "10.0.0.0/16"
  public_subnets_list  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets_list = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  just_count           = 3
  enable_db_subnet_group    = true
}

module "db" {
  source                     = "./modules/db"
  app_name                   = local.app_name
  availability_zones         = slice(data.aws_availability_zones.available.names, 0, 3)
  database_name              = "dbname"
  vpc_id                     = module.networking.vpc_id
  vpc_rds_security_group_ids = [module.sg.vpc_rds_security_group_ids]
  db_subnet_group            = module.networking.db_subnet_group
  master_username            = "stoyandg"
  master_password            = local.master_password
  depends_on                 = [module.networking]
}

module "bastion" {
  source    = "./modules/asg"
  name      = "bast"
  image_id  = "ami-051270933c06fc174"
  key_name  = local.ssh_key_name
  user_data = "#!/bin/bash\nhostnamectl set-hostname bastion"

  enable_network_load_balancer = true
  loadbalancer_port            = 22
  health_check_port            = 22
  loadbalancer_subnet_ids      = module.networking.public_subnets_id
  autoscaling_group_subnet_ids = module.networking.public_subnets_id
  public_security_group_ids    = [module.sg.vpc_public_security_group_ids]
  vpc_id                       = module.networking.vpc_id
  depends_on                   = [module.apache]
}

module "apache" {
  source    = "./modules/asg"
  name      = "apache"
  image_id  = "ami-0a8b8f320c122619d"
  key_name  = local.ssh_key_name
  user_data = "#!/bin/bash\nhostnamectl set-hostname apache"

  enable_application_load_balancer = true
  loadbalancer_port                = 80
  health_check_port                = 80
  loadbalancer_subnet_ids          = module.networking.public_subnets_id
  autoscaling_group_subnet_ids     = module.networking.private_subnets_id
  public_security_group_ids        = [module.sg.vpc_public_security_group_ids]
  vpc_id                           = module.networking.vpc_id
  depends_on                       = [module.db]
}


module "sg" {
  source = "./modules/sg"

  app_name                          = local.app_name
  vpc_id                            = module.networking.vpc_id
  vpc_public_security_group_ids     = [module.sg.vpc_public_security_group_ids]
  vpc_prometheus_security_group_ids = [module.sg.vpc_prometheus_security_group_ids]
  vpc_private_security_group_ids    = [module.sg.vpc_private_security_group_ids]
}

module "prometheus" {
  source = "./modules/prometheus"

  app_name                          = local.app_name
  vpc_id                            = module.networking.vpc_id
  public_subnets_id                 = module.networking.public_subnets_id
  vpc_prometheus_security_group_ids = [module.sg.vpc_prometheus_security_group_ids]
}

module "grafana" {
  source = "./modules/grafana"

  prometheus_public_ip           = module.prometheus.prometheus_public_ip
  app_name                       = local.app_name
  vpc_id                         = module.networking.vpc_id
  public_subnets_id              = module.networking.public_subnets_id
  vpc_grafana_security_group_ids = [module.sg.vpc_grafana_security_group_ids]
}
