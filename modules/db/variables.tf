variable "app_name" {}

variable "vpc_id" {}

variable "master_password" {}

variable "vpc_rds_security_group_ids" {}

variable "db_subnet_group" {
  description = "A subnet group for the database instances"
  type = string
}

variable "availability_zones" {
  description = "A list of availability zones in which the subnets will be created"
  type        = list(any)
}

variable "master_username" {
  description = "Username for the database"
  type        = string
}

variable "engine" {
  description = "The engine that the database runs on"
  type        = string
  default     = "aurora"
}

variable "database_name" {
  description = "The name of the database"
  type        = string
}

variable "instance_class" {
  description = "The instance class type for the database"
  type        = string
  default     = "db.t3.small"
}

variable "rds_cluster_instance_count" {
  description = "Sets the amount of AWS RDS Cluster instances to be created."
  type = number
  default = 1
}