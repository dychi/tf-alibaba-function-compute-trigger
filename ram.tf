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


resource "alicloud_ram_role" "trigger_role" {
  name = "AliyunTableStoreStreamNotificationRole"
  document = jsonencode({
    Version = "1"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = [
            "ots.aliyuncs.com"
          ]
          RAM = [
            "acs:ram::1604337383174619:root"
          ]
        }
      }
    ]
  })
  description = "trigger role for OTS to invoke functions of {serviceName}"
  timeouts {}
}

resource "alicloud_ram_policy" "trigger_policy" {
  policy_name = "AliyunTableStoreStreamNotificationRolePolicy"
  policy_document = jsonencode({
    "Version" : "1",
    "Statement" : [
      {
        "Action" : [
          "ots:BatchGet*",
          "ots:Describe*",
          "ots:Get*",
          "ots:List*"
        ],
        "Resource" : "*",
        "Effect" : "Allow"
      },
      {
        "Action" : [
          "fc:InvokeFunction"
        ],
        "Resource" : "*",
        "Effect" : "Allow"
      }
    ]
  })
  # description = "Function Compute サービス関数をトリガーするための TableStore Stream の認可ポリシー"
  description = "用于TableStore Stream 触发函数计算服务function的授权策略"
  timeouts {}
}

resource "alicloud_ram_role_policy_attachment" "trigger_policy_attach" {
  policy_name = alicloud_ram_policy.trigger_policy.policy_name
  policy_type = "Custom"
  role_name   = alicloud_ram_role.trigger_role.name
  timeouts {}
  depends_on = [
    alicloud_ram_role.trigger_role
  ]
}
