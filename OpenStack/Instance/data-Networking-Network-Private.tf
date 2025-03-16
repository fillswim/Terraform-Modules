
# Находим сеть по имени
data "openstack_networking_network_v2" "private_network" {
  name = var.private-network-name
}

# Находим подсеть в сети по id сети и названию подсети
data "openstack_networking_subnet_v2" "private_subnet" {
  network_id = data.openstack_networking_network_v2.private_network.id
  name       = var.private-subnet-name
}