provider "aws" {
    region = var.region
}

module "networking" {
    source = "./modules/networking"
}

module "sg" {
    source = "./modules/sg"
}