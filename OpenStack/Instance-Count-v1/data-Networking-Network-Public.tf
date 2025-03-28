
data "openstack_networking_network_v2" "public_network" {
  name = var.public-network-name
}

output "public_network_id" {
  value = data.openstack_networking_network_v2.public_network.id
}