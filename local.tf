locals {
  region                  = "ap-northeast-1"
  zone                    = "ap-northeast-1a"
  trigger_table_store_arn = "acs:ots:${local.region}:${data.alicloud_account.current.id}:instance/${alicloud_ots_instance.test_instance.name}/table/${alicloud_ots_table.test_forms.table_name}"
}
