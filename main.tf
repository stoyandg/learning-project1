provider "aws" {
    region = var.region
}

module "networking" {
    source = "./modules/networking"

    app-name = var.app-name
    id_of_vpc = module.networking.id_of_vpc
}

module "sg" {
    source = "./modules/sg"
}