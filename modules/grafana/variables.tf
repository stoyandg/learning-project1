variable "prometheus_public_ip" {}

variable "app-name" {}

variable "id_of_vpc" {}

variable "vpc_grafana_security_group_ids" {}

variable "both_public_subnets_id" {}

variable "instance_type" {
    type = string
    default = "t2.micro"
}

variable "az" {
    type = string
    default = "us-west-2a"
}