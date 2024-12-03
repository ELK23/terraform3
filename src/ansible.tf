resource "local_file" "ansible_inventory" {
  filename = "${path.module}/for.ini"
  content  = templatefile("${path.module}/hosts.tftpl", {
    web_vms      = var.web_vms
    db_vms       = var.db_vms
    storage_vms  = var.storage_vms
  })
}
