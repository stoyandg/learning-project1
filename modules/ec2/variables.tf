variable "app_name" {}

variable "vpc_grafana_security_group_ids" {}

variable "vpc_prometheus_security_group_ids" {}

variable "public_subnets_id" {}

variable "image_id" {
  description = "Image ID for EC2 Instances"
  type        = string
}

variable "instance_type" {
  description = "Instance type"
  type        = string
  default     = "t2.micro"
}

variable "az" {
  type    = string
  default = "us-west-2a"
}

variable "key_name" {
  description = "Name of SSH Key Pair"
  type        = string
}

variable "user_data" {
  description = "UserData to pass to EC2 Instance"
  type        = string
}

variable "associate_public_ip_address" {
    description = "Whether to associate a public IP address to the EC2 instance"
    type        = bool
    default     = true
}

variable "private_ip" {
    description = "Sets the private IP of the EC2 instance"
    type = string
}