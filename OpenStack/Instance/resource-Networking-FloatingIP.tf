
# Создать плавающий IP
resource "openstack_networking_floatingip_v2" "floatip" {
  pool    = data.openstack_networking_network_v2.public_network.name
  address = var.floating-ip-v4
}

# Связать плавающий IP c портом инстанса
# data.openstack_networking_port_v2.port.id - порт внутреннего адреса
resource "openstack_networking_floatingip_associate_v2" "fip_associate" {
  floating_ip = var.floating-ip-v4
  port_id     = data.openstack_networking_port_v2.port.id
}