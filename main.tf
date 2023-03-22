provider "aws" {
    region = var.region
}

module "networking" {
    source = "./modules/networking"

    app-name = var.app-name
    id_of_vpc = module.networking.id_of_vpc
    both_private_subnets_id = [module.networking.both_private_subnets_id]
}

module "sg" {
    source = "./modules/sg"

    app-name = var.app-name
    id_of_vpc = module.networking.id_of_vpc
    vpc_public_security_group_ids = [module.sg.vpc_public_security_group_ids]
}

module "db" {
    source = "./modules/db"

    app-name = var.app-name
    id_of_vpc = module.networking.id_of_vpc
    vpc_private_security_group_ids = [module.sg.vpc_private_security_group_ids]
    both_db_subnets_name = module.networking.both_db_subnets_name
    master_password = var.master_password
    depends_on = [module.networking.db_subnets]
}

module "apache" {
    source = "./modules/apache"

    app-name = var.app-name
    id_of_vpc = module.networking.id_of_vpc
    both_private_subnets_id = module.networking.both_private_subnets_id
    both_public_subnets_id = module.networking.both_public_subnets_id
    vpc_private_security_group_ids = [module.sg.vpc_private_security_group_ids]
    vpc_public_security_group_ids = [module.sg.vpc_public_security_group_ids]

    depends_on = [module.db.db_instance]
}

module "bastion" {
    source = "./modules/bastion"

    app-name = var.app-name
    id_of_vpc = module.networking.id_of_vpc
    both_public_subnets_id = module.networking.both_public_subnets_id
    vpc_public_security_group_ids = [module.sg.vpc_public_security_group_ids]

    depends_on = [module.apache.apache-autoscaling]
}