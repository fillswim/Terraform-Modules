
# Create a private subnet
resource "openstack_networking_subnet_v2" "private_subnet_1" {
  tenant_id       = data.openstack_identity_project_v3.project.id
  name            = var.private_subnet_name
  network_id      = openstack_networking_network_v2.private_network.id
  cidr            = var.private_subnet_cidr
  dns_nameservers = var.private_subnet_dns_nameservers
  gateway_ip      = var.private_subnet_gateway_ip
}