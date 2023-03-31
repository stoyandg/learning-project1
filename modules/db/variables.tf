variable "app-name" {}

variable "vpc_id" {}

variable "master_password" {}

variable "vpc_rds_security_group_ids" {}

variable "db_subnets_name" {}

variable "availability_zones" {
    description = "A list of availability zones in which the subnets will be created"
    type = list
}

variable "master_username" {
    description = "Username for the database"
    type = string
}

variable "engine" {
    description = "The engine that the database runs on"
    type = string
    default = "aurora"
}

variable "database_name" {
    description = "The engine that the database runs on"
    type = string
}

variable "instance_class" {
    description = "The engine that the database runs on"
    type = string
    default = "db.t3.small"
}