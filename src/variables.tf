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

variable "security_group_id" {
  type        = list
  default     = ["enppnvqd1388ibcdil9p"]
  description = "Security group ID for the instance"
}

variable "storage_disk_size" {
  type        = number
  default     = 1
  description = "Size of each storage disk in GB"
}
variable "storage_disk_count" {
  type        = number
  default     = 3
  description = "Number of additional storage devices"
}

variable "storage_disk_type" {
  type        = string
  default     = "network-hdd"
  description = "Type of additional storage disks"
}

variable "storage_vm" {
  type = object({
    name        = string
    platform_id = string
    memory      = number
    cores       = number
    boot_disk = object({
      size  = number
      type  = string
      image = string
    })
  })
  default = {
    name        = "storage"
    platform_id = "standard-v1"
    memory      = 2
    cores       = 2
    boot_disk = {
      size  = 20
      type  = "network-hdd"
      image = "fd8chrq89mmk8tqm85r8"
    }
  }
}


variable "template_vm" {
  type = object({
    name        = string
    platform_id = string
    memory      = number
    cores       = number
    boot_disk = object({
      size  = number
      type  = string
      image = string
    })
  })
  default = {
    name        = "storage"
    platform_id = "standard-v1"
    memory      = 2
    cores       = 2
    boot_disk = {
      size  = 20
      type  = "network-hdd"
      image = "fd8chrq89mmk8tqm85r8"
    }
  }
}



variable "ssh_key_path" {
  type        = string
  default     = "~/yan.pub"
  description = "Path to the SSH public key"
}




variable "web_vms" {
  default = [
    {
      name        = "web-1"
      fqdn        = "web1.ru-central1.internal"
    },
    {
      name        = "web-2"
      fqdn        = "web2.ru-central1.internal"
    }
  ]
}

variable "db_vms" {
  default = [
    {
      name        = "main"
      fqdn        = "main.db.ru-central1.internal"
    },
    {
      name        = "replica"
      fqdn        = "replica.db.ru-central1.internal"
    }
  ]
}
variable "storage_vms" {
  default = [
    {
      name        = "storage"
      fqdn        = "storage.ru-central1.internal"
    }
  ]
}



variable "base_ips" {
  type = map(string)
  default = {
    web     = "10.0.1.2/24"
  }
}


locals {
  db_base_ip = format("%s/24", cidrhost(var.base_ips["web"], 10))
  storage_base_ip = format("%s/24", cidrhost(var.base_ips["web"], 20)) 
  web_vms = [
    for idx, vm in var.web_vms : merge(vm, {
      external_ip = cidrhost(var.base_ips["web"], idx + 1)
    })
  ]

  db_vms = [
    for idx, vm in var.db_vms : merge(vm, {
      external_ip = cidrhost(local.db_base_ip, idx + 1)
    })
  ]

  storage_vms = [
    for idx, vm in var.storage_vms : merge(vm, {
      external_ip = cidrhost(local.storage_base_ip, idx + 1)
    })
  ]
}
