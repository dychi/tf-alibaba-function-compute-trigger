resource "alicloud_fcv3_function" "table_store" {
  function_name = "tablestore-trigger-func"
  memory_size   = "512"
  timeout       = "60"
  runtime       = "nodejs18"
  handler       = "index.handler"
  cpu           = "0.35"
  disk_size     = "512"
  code {
    zip_file = filebase64("${path.module}/src/tablestore-trigger-func-code.zip")
  }
  role = alicloud_ram_role.fc_default.arn
  log_config {
    log_begin_rule = "DefaultRegex"
    logstore       = alicloud_log_store.main.logstore_name
    project        = alicloud_log_project.main.project_name
  }

  environment_variables = {
    "TZ" = "Asia/Tokyo"
  }
  timeouts {}
  internet_access = "true"
}

resource "alicloud_fcv3_trigger" "trigger" {
  trigger_type    = "tablestore"
  trigger_name    = "test-tablestore-trigger"
  qualifier       = "LATEST"
  trigger_config  = jsonencode({})
  source_arn      = local.trigger_table_store_arn
  invocation_role = alicloud_ram_role.trigger_role.arn
  function_name   = alicloud_fcv3_function.table_store.function_name
  timeouts {}
}
