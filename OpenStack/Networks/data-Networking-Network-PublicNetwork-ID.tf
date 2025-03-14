
data "openstack_networking_network_v2" "public_network" {
  name = var.public_network_name
}

output "public_network_id" {
  value = data.openstack_networking_network_v2.public_network.id
}
