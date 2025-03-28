
# Создать внешний диск
resource "openstack_blockstorage_volume_v3" "external_block_storage" {
  name        = var.name
  size        = var.size
  volume_type = var.volume-type
}

# Прикрепить внешний диск к инстансу
resource "openstack_compute_volume_attach_v2" "external_block_storage_attach" {
  instance_id = var.instance-id
  volume_id   = openstack_blockstorage_volume_v3.external_block_storage.id
}

# Вывод информации об внешнем диске
output "details" {
  value = {
    name        = openstack_blockstorage_volume_v3.external_block_storage.name
    size        = openstack_blockstorage_volume_v3.external_block_storage.size
    volume_type = openstack_blockstorage_volume_v3.external_block_storage.volume_type
    instance_id = openstack_compute_volume_attach_v2.external_block_storage_attach.instance_id
  }
}