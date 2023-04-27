terraform {
  required_providers {
    grafana = {
      source  = "grafana/grafana"
      version = "1.38.0"
    }
  }
}

provider "grafana" {
  alias = "first"
  url   = "http://${aws_instance.grafana.public_ip}:3000"
  auth  = var.auth
}

resource "aws_instance" "grafana" {
  ami                    = "ami-04efc0b5be2a4d3ad"
  instance_type          = var.instance_type
  availability_zone      = var.az
  vpc_security_group_ids = var.vpc_grafana_security_group_ids
  subnet_id              = element(var.public_subnets_id, 0)
  key_name               = "learning-project1-key-pair"
  user_data = (base64encode(<<EOF
#!/bin/bash
hostnamectl set-hostname grafana
EOF
  ))
}

resource "grafana_data_source" "test_data_source" {
  provider = grafana.first

  name       = "Prometheus"
  type       = "prometheus"
  url        = "http://${var.prometheus_public_ip}:9090"
  is_default = true
}
resource "grafana_folder" "test_folder" {
  provider = grafana.first

  title = "Test Folder"
}

resource "grafana_dashboard" "dashboard" {
  provider = grafana.first

  config_json = file("${path.module}/dashboard.json")
  folder      = grafana_folder.test_folder.id
}
