# ==============================================================================
#                              Получение ID образа
# ==============================================================================

data "openstack_images_image_v2" "image" {
  name        = var.image-name
  most_recent = true
}

# Вывод ID образа
output "image-id" {
  value = data.openstack_images_image_v2.image.id
}

# ==============================================================================
#                                Создать инстанс
# ==============================================================================

# Создать инстанс
resource "openstack_compute_instance_v2" "instance" {
  name        = var.instance-name
  image_name  = var.image-name
  flavor_name = var.flavor-name

  key_pair        = var.keypair-name
  security_groups = [var.security-group-name]

  # Корневой диск
  block_device {
    uuid                  = data.openstack_images_image_v2.image.id
    delete_on_termination = true
    source_type           = "image"
    destination_type      = "volume"
    volume_size           = var.root-volume-size
    boot_index            = 0
  }

  # Сеть
  network {
    name        = var.private-network-name
    fixed_ip_v4 = var.fixed-ip-v4
  }

  user_data = file(var.user-data)

}

# ==============================================================================
#                            Вывод информации об инстансе
# ==============================================================================

output "name" {
  value = openstack_compute_instance_v2.instance.name
}

output "instance-id" {
  value = openstack_compute_instance_v2.instance.id
}

output "flavor_name" {
  value = openstack_compute_instance_v2.instance.flavor_name
}

output "fixed_ip_v4" {
  value = openstack_compute_instance_v2.instance.network[0].fixed_ip_v4
}

output "details" {
  value = {
    name                 = openstack_compute_instance_v2.instance.name
    flavor_name          = openstack_compute_instance_v2.instance.flavor_name
    fixed_ip_v4          = openstack_compute_instance_v2.instance.network[0].fixed_ip_v4
    disk_size            = openstack_compute_instance_v2.instance.block_device[0].volume_size
    image_name           = openstack_compute_instance_v2.instance.image_name
    private_network_name = openstack_compute_instance_v2.instance.network[0].name
  }
}
