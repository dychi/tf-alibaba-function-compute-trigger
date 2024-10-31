resource "alicloud_log_project" "trigger_table_store" {
  project_name = var.sls_project_name
}

resource "alicloud_log_store" "trigger_table_store" {
  project_name          = alicloud_log_project.trigger_table_store.id
  logstore_name         = "function-log"
  shard_count           = 3
  auto_split            = true
  max_split_shard_count = 64
  retention_period      = 90
  enable_web_tracking   = true
  append_meta           = false
  timeouts {}
}
