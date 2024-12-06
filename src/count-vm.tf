resource "yandex_compute_instance" "web" {
  count = 2

  name        = "web-${count.index + 1}"
  platform_id = var.template_vm.platform_id
  zone        = var.default_zone

  boot_disk {
    initialize_params {
      image_id = var.template_vm.boot_disk.image
      size     = var.template_vm.boot_disk.size
      type     = var.template_vm.boot_disk.type
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true

    security_group_ids = var.security_group_id
  }

  resources {
    memory = var.template_vm.memory
    cores  = var.template_vm.cores
  }

  metadata = {
    ssh-keys = var.ssh_key_path
  }
}
