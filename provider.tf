provider "aws" {
  region = local.region
}

provider "grafana" {
  # alias = "first"
  url   = "http://${module.grafana.ec2_instance_public_ip}:3000"
  auth  = "admin:admin"
}

terraform {
  required_providers {
    grafana = {
      source  = "grafana/grafana"
      version = "1.38.0"
    }
    aws = {
      source = "hashicorp/aws"
      version = "4.60.0"
    }
  }
}
