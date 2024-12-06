resource "yandex_compute_disk" "storage_disk" {
  count = var.storage_disk_count

  name = "storage-disk-${count.index + 1}"
  size = var.storage_disk_size
  type = var.storage_disk_type
  zone = var.default_zone
}

resource "yandex_compute_instance" "storage" {
  name        = var.storage_vm.name
  platform_id = var.storage_vm.platform_id
  zone        = var.default_zone

  boot_disk {
    initialize_params {
      image_id = var.storage_vm.boot_disk.image
      size     = var.storage_vm.boot_disk.size
      type     = var.storage_vm.boot_disk.type
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
    security_group_ids = var.security_group_id
  }

  resources {
    memory = var.storage_vm.memory
    cores  = var.storage_vm.cores
  }

  metadata = {
    ssh-keys = var.ssh_key_path
  }

  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.storage_disk
    content {
      disk_id = secondary_disk.value.id
    }
  }
}
