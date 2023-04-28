provider "aws" {
  region = local.region
}



terraform {
  required_version = "v1.2.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.60.0"
    }
  }
}
