provider "aws" {
  region = local.region
}

terraform {
  required_providers {
    grafana = {
      source  = "grafana/grafana"
      version = "1.36.1"
    }
  }
}
