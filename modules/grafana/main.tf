# resource "grafana_data_source" "test_data_source" {
#   # provider = grafana.first

#   name       = "Prometheus"
#   type       = "prometheus"
#   url        = "http://${var.prometheus_public_ip}:9090"
#   is_default = true
#}
resource "grafana_folder" "test_folder" {
  # provider = grafana.first

  title = "Test Folder"
}

# resource "grafana_dashboard" "dashboard" {
#   # provider = grafana.first

#   config_json = file("${path.module}/dashboard.json")
#   folder      = grafana_folder.test_folder.id
# }
