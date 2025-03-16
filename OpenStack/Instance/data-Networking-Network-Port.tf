
# Получить порт инстанса по его IP
data "openstack_networking_port_v2" "port" {
  fixed_ip  = openstack_compute_instance_v2.instance[0].access_ip_v4
}
