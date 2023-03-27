resource "grafana_dashboard" "dashboard" {
    provider = grafana.second

    config_json = file("${path.module}/dashboard.json")
    folder = grafana_folder.test-folder.id
}
