
# Получить порт инстанса по его IP
data "openstack_networking_port_v2" "port" {
  fixed_ip  = var.instance-ip-v4
  device_id = openstack_compute_instance_v2.instance.id
}

output "port_id" {
  value = data.openstack_networking_port_v2.port.id
}
