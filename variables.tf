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

variable "sls_project_name" {
  description = "The name of the Log Service project"
  type        = string
}

variable "resource_group_id" {
  description = "The ID of the resource group"
  type        = string
}
