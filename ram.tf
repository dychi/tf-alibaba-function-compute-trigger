# Function Computeのデフォルトロール
resource "alicloud_ram_role" "fc_default" {
  name = "AliyunFcDefaultRole"
  document = jsonencode({
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : [
            "fc.aliyuncs.com"
          ]
        }
      }
    ],
    "Version" : "1"
  })
  description = "Default Service Role for FC to operate other resource"
}

# デフォルトのポリシーをアタッチ
resource "alicloud_ram_role_policy_attachment" "fc_default_policy" {
  policy_name = "AliyunFCDefaultRolePolicy"
  policy_type = "System"
  role_name   = alicloud_ram_role.fc_default.name
  depends_on = [
    alicloud_ram_role.fc_default
  ]
}

// TableStore Stream から Function Compute サービス関数をトリガーするためのロールとポリシーを作成
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
            "acs:ram::${var.alicloud_account_id}:root" // Alibaba Cloud Account ID(自分のとは異なる)
          ]
        }
      }
    ]
  })
  description = "trigger role for OTS to invoke functions of {serviceName}"
  timeouts {}
}

# TableStore Stream から Function Compute サービス関数をトリガーするためのポリシー
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

# TableStore Stream から Function Compute サービス関数をトリガーするためのロールにポリシーをアタッチ
resource "alicloud_ram_role_policy_attachment" "trigger_policy_attach" {
  policy_name = alicloud_ram_policy.trigger_policy.policy_name
  policy_type = "Custom"
  role_name   = alicloud_ram_role.trigger_role.name
  timeouts {}
  depends_on = [
    alicloud_ram_role.trigger_role
  ]
}
