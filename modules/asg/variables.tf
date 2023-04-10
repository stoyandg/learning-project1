variable "name" {
  description = "The name of the objects"
  type        = string
}

variable "device_name" {
  description = "Name of storage device for launch template"
  type        = string
  default     = "/dev/xvda"
}

variable "volume_size" {
  description = "Size of EBS Volume for launch template"
  type        = number
  default     = 8
}

variable "volume_type" {
  description = "Type of EBS Volume for launch template"
  type        = string
  default     = "gp2"
}

variable "volume_delete_on_termination" {
  description = "delete_on_termination flag for EBS Volume for launch template"
  type        = bool
  default     = true
}

variable "image_id" {
  description = "Image ID for EC2 Instances"
  type        = string
}

variable "instance_type" {
  description = "Instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Name of SSH Key Pair"
  type        = string
}

variable "user_data" {
  description = "UserData to pass to EC2 Instance"
  type        = string
}

variable "desired_capacity" {
  description = "Desired capacity for AutoScalingGroup"
  type        = number
  default     = 1
}

variable "max_size_capacity" {
  description = "Max size of desired capacity for AutoScalingGroup"
  type        = number
  default     = 1
}

variable "min_size_capacity" {
  description = "Min size of desired capacity for AutoScalingGroup"
  type        = number
  default     = 1
}

variable "health_check_type" {
  description = "The type of health check in LoadBalancer"
  type        = string
  default     = "EC2"
}

variable "loadbalancer_subnet_ids" {
  description = "The IDs of subnets for LoadBalancer"
  type        = list(string)
  default     = []
}

variable "autoscaling_group_subnet_ids" {
  description = "The IDs of subnets for AutoScaling Group"
  type        = list(string)
  default     = []
}

variable "internal_load_balancer" {
  description = "Type of LoadBalancer"
  type        = bool
  default     = false
}

variable "enable_network_load_balancer" {
  description = "Use Network LoadBalancer Type"
  type        = bool
  default     = false
}

variable "enable_application_load_balancer" {
  description = "Use Application LoadBalancer Type"
  type        = bool
  default     = false
}

variable "enable_cross_zone_load_balancing" {
  description = "Cross-zone LoadBalancing"
  type        = bool
  default     = true
}

variable "loadbalancer_port" {
  description = "Number of port to be opened in LoadBalancer"
  type        = number
}

variable "public_security_group_ids" {
  description = "IDs of SecurityGroups in Public Network"
  type        = list(string)
}

variable "health_check_port" {
  description = "Number of port to use for LoadBalancer HealthCheck"
  type        = number
}

variable "vpc_id" {
  description = "ID of VPC"
  type        = string
}
