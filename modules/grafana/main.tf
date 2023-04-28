# resource "grafana_data_source" "test_data_source" {
#   # provider = grafana.first

#   name       = "Prometheus"
#   type       = "prometheus"
#   url        = "http://${var.prometheus_public_ip}:9090"
#   is_default = true
#}
resource "grafana_folder" "test_folder" {
  title = "Test Folder"
}

resource "grafana_dashboard" "dashboard" {
  config_json = file("${path.module}/dashboard.json")
  folder      = grafana_folder.test_folder.id
}

terraform {
  required_providers {
    grafana = {
      source  = "grafana/grafana"
      version = "1.38.0"
    }
  }
}

provider "grafana" {
  url  = "http://${var.grafana_public_ip}:3000"
  auth = var.auth
}
