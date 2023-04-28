variable "prometheus_public_ip" {
  description = "The public IP of the Prometheus EC2 instance"
}

variable "grafana_public_ip" {
  description = "The public IP of the Grafana EC2 instance"
}

variable "auth" {
  type    = string
  default = "admin:admin"
}

# variable "app_name" {}

# variable "vpc_id" {}

# variable "vpc_grafana_security_group_ids" {}

# variable "public_subnets_id" {}



# variable "instance_type" {
#   type    = string
#   default = "t2.micro"
# }

# variable "az" {
#   type    = string
#   default = "us-west-2a"
# }
