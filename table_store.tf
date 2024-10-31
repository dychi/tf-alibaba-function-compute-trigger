resource "alicloud_ots_instance" "test_instance" {
  name          = "test-fc"
  accessed_by   = "Any"
  instance_type = "Capacity"
  network_type_acl = [
    "VPC",
    "CLASSIC",
    "INTERNET"
  ]
  resource_group_id = var.resource_group_id
  tags = {
    env = "test"
  }
}

resource "alicloud_ots_table" "event_forms" {
  instance_name = alicloud_ots_instance.test_instance.name
  table_name    = "event_forms"
  time_to_live  = -1
  max_version   = 1
  primary_key {
    name = "PK"
    type = "String"
  }

  depends_on = [
    alicloud_ots_instance.test_instance
  ]
}
