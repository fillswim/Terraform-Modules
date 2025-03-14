
data "openstack_networking_network_v2" "private_network" {
  name = var.private-network-name
}

output "private_network_name" {
  value = data.openstack_networking_network_v2.private_network.name
}
