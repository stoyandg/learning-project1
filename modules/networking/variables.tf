variable "cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "public_subnets_list" {
  description = "A list of the CIDR blocks for the public subnets"
  type        = list(any)
}

variable "private_subnets_list" {
  description = "A list of the CIDR blocks for the private subnets"
  type        = list(any)
}

variable "availability_zones" {
  description = "A list of availability zones in which the subnets will be created"
  type        = list(any)
}

variable "route_cidr_block" {
  description = "The CIDR block for the public and private route tables"
  type        = string
  default     = "0.0.0.0/0"
}

variable "just_count" {
  description = "A variable for the amount of resources that need to be created"
  type        = number
}

variable "enable_db_subnet_group" {
  description = "A variable whether to create a DB subnets group"
  type        = bool
  default     = false
}

variable "app_name" {
  description = "A name for the resources to be provisioned"
  type        = string
}
