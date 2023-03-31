variable "app-name" {}

variable "vpc_id" {}

variable "public_subnets_id" {}

variable "vpc_prometheus_security_group_ids" {}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "az" {
  type    = string
  default = "us-west-2a"
}