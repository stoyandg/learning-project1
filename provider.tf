provider "aws" {
  region = local.region
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
