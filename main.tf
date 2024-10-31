terraform {
  required_version = "1.9.5"
  required_providers {
    alicloud = {
      source  = "aliyun/alicloud"
      version = "1.231.0"
    }
  }
}

provider "alicloud" {
  region     = "ap-northeast-1"
  access_key = var.access_key
  secret_key = var.secret_key
}
