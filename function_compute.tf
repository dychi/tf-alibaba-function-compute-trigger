resource "alicloud_fcv3_function" "trigger_table_store" {
  function_name = "test-tablestora-trigger-func"
  memory_size   = "512"
  timeout       = "60"
  runtime       = "nodejs16"
  handler       = "index.handler"
  cpu           = "0.35"
  disk_size     = "512"
  role          = alicloud_ram_role.fc_default.arn
  log_config {
    log_begin_rule = "DefaultRegex"
    logstore       = alicloud_log_store.trigger_table_store.logstore_name
    project        = alicloud_log_project.trigger_table_store.project_name
  }

  environment_variables = {
    "TZ" = "Asia/Tokyo"
  }
  timeouts {}
  internet_access = "true"
}

resource "alicloud_fcv3_trigger" "trigger_table_store" {
  trigger_type    = "tablestore"
  trigger_name    = "test-tablestore-trigger"
  qualifier       = "LATEST"
  trigger_config  = jsonencode({})
  source_arn      = local.trigger_table_store_arn
  invocation_role = alicloud_ram_role.trigger_role.arn
  function_name   = alicloud_fcv3_function.trigger_table_store.function_name
  timeouts {}
}
