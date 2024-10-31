# SLSのプロジェクト
resource "alicloud_log_project" "main" {
  project_name = "function-compute-log"
}

# SLSのログストア
resource "alicloud_log_store" "main" {
  project_name          = alicloud_log_project.main.id
  logstore_name         = "function-log"
  shard_count           = 3
  auto_split            = true
  max_split_shard_count = 64
  retention_period      = 90
  enable_web_tracking   = true
  append_meta           = false
  timeouts {}
  depends_on = [
    alicloud_log_project.main
  ]
}
