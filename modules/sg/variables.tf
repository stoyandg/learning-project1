variable "allowed_ports_public" {
    description = "List of all allowed ports except 22"
    type = list(any)
    default = ["80", "443"]
}

variable "vpc_public_security_group_ids" {
    type = set(string)
}

variable "app-name" {}

variable "id_of_vpc" {}