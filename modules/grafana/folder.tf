resource "grafana_folder" "test-folder" {
    provider = grafana.second

    title = "test-folder"
}