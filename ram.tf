resource "alicloud_ram_role" "fc_default" {
  name        = "AliyunFcDefaultRole"
  document    = <<EOF
  {
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Effect": "Allow",
        "Principal": {
          "Service": [
            "fc.aliyuncs.com"
          ]
        }
      }
    ],
    "Version": "1"
}
  EOF
  description = "Default Service Role for FC to operate other resource"
}

resource "alicloud_ram_role_policy_attachment" "fc_default_policy" {
  policy_name = "AliyunFCDefaultRolePolicy"
  policy_type = "System"
  role_name   = alicloud_ram_role.fc_default.name
  depends_on = [
    alicloud_ram_role.fc_default
  ]
}
