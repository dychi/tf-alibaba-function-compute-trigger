variable "access_key" {
  description = "The access key for the Alibaba Cloud account"
  type        = string
  sensitive   = true
}
variable "secret_key" {
  description = "The secret key for the Alibaba Cloud account"
  type        = string
  sensitive   = true
}

variable "resource_group_id" {
  description = "The ID of the resource group"
  type        = string
}

variable "alicloud_account_id" {
  description = "The ID of the Alibaba Cloud account"
  type        = string

}
