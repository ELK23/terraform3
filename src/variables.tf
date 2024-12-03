###cloud vars
variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network&subnet name"
}


variable "web_vms" {
  default = [
    {
      name        = "web-1"
      external_ip = "10.0.1.1"
      fqdn        = "web1.ru-central1.internal"
    },
    {
      name        = "web-2"
      external_ip = "10.0.1.2"
      fqdn        = "web2.ru-central1.internal"
    }
  ]
}

variable "db_vms" {
  default = [
    {
      name        = "main"
      external_ip = "10.0.1.3"
      fqdn        = "main.db.ru-central1.internal"
    },
    {
      name        = "replica"
      external_ip = "10.0.1.4"
      fqdn        = "replica.db.ru-central1.internal"
    }
  ]
}

variable "storage_vms" {
  default = [
    {
      name        = "storage"
      external_ip = "10.0.1.5"
      fqdn        = "storage.ru-central1.internal"
    }
  ]
}


