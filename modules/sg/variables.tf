variable "allowed_ports_public" {
    description = "List of all allowed ports except 22"
    type = list(any)
    default = ["80", "443", "9100"]
}

variable "allowed_ports_prometheus" {
    description = "List of all allowed ports except 22"
    type = list(any)
    default = ["22", "443", "9090", "9100"]
}

variable "vpc_public_security_group_ids" {
    type = set(string)
}

variable "vpc_prometheus_security_group_ids" {
    type = set(string)
}

variable "app-name" {}

variable "id_of_vpc" {}