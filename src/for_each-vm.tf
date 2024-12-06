locals {
  db_defaults = [
    {
      vm_name    = "main"
      cpu        = var.template_vm.memory
      ram        = var.template_vm.cores
      disk_volume = var.template_vm.boot_disk.size
    },
    {
      vm_name    = "replica"
      cpu        = var.template_vm.memory
      ram        = var.template_vm.cores
      disk_volume = var.template_vm.boot_disk.size
    }
  ]
}



resource "yandex_compute_instance" "db" {
  for_each = { for v in local.db_defaults : v.vm_name => v }

  name        = each.value.vm_name
  platform_id = var.template_vm.platform_id
  zone        = var.default_zone

  boot_disk {
    initialize_params {
      image_id = var.template_vm.boot_disk.image
      size     = each.value.disk_volume
      type     = var.template_vm.boot_disk.type
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true

    security_group_ids = var.security_group_id
  }

  resources {
    memory = each.value.ram
    cores  = each.value.cpu
  }

  metadata = {
    ssh-keys = var.ssh_key_path
  }
}
