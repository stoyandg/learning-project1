variable "app-name" {}

variable "id_of_vpc" {}

variable "cidr" {
    description = "The CIDR block for the VPC"
    default = "10.0.0.0/16"
}

variable "public_subnets_list" {
    description = "A list of the CIDR blocks for the public subnets"
    type = list
    default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnets_list" {
    description = "A list of the CIDR blocks for the private subnets"
    type = list
    default = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

variable "availability_zones" {
    description = "A list of availability zones in which the subnets will be created"
    type = list
    default = ["us-west-2a", "us-west-2b", "us-west-2c"]
}

variable "route_cidr_block" {
    description = "The CIDR block for the public and private route tables"
    default = "0.0.0.0/0"
}

variable "both_private_subnets_id" {}

variable "just_count" {
    description = "A variable for the amount of resources that need to be created"
    default = 3
}

