resource "grafana_data_source" "test-data-source" {
    provider = grafana.second

    name = "Prometheus"
    type = "prometheus"
    url = "http://${var.prometheus_public_ip}:9090"
    is_default = true

}