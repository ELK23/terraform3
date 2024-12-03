resource "yandex_compute_instance" "web" {
  count = 2

  name        = "web-${count.index + 1}"
  platform_id = "standard-v1"
  zone        = var.default_zone

  boot_disk {
    initialize_params {
      image_id = "fd8chrq89mmk8tqm85r8"
      size     = 30
      type     = "network-hdd"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true

    security_group_ids = ["enppnvqd1388ibcdil9p"]
  }

  resources {
    memory = 2
    cores  = 2
  }

  metadata = {
    ssh-keys = file("~/yan.pub")
  }
}
