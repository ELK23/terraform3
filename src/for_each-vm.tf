# for_each-vm.tf
variable "each_vm" {
  type = list(object({
    vm_name    = string
    cpu        = number
    ram        = number
    disk_volume = number
  }))
  default = [
    {
      vm_name    = "main"
      cpu        = 2
      ram        = 4
      disk_volume = 20
    },
    {
      vm_name    = "replica"
      cpu        = 2
      ram        = 2
      disk_volume = 21
    }
  ]
}

resource "yandex_compute_instance" "db" {
  for_each = { for v in var.each_vm : v.vm_name => v }

  name        = each.value.vm_name
  platform_id = "standard-v1"
  zone        = var.default_zone

  boot_disk {
    initialize_params {
      image_id = "fd8chrq89mmk8tqm85r8"
      size     = each.value.disk_volume
      type     = "network-hdd"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true

    security_group_ids = ["enppnvqd1388ibcdil9p"]
  }

  resources {
    memory = each.value.ram
    cores  = each.value.cpu
  }

  metadata = {
    ssh-keys = file("~/yan.pub")
  }
}
