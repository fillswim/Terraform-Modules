
# Create a port for the private network for router
resource "openstack_networking_port_v2" "private_port_1" {
  tenant_id      = data.openstack_identity_project_v3.project.id
  name           = var.private_port_1_name
  network_id     = openstack_networking_network_v2.private_network.id
  admin_state_up = true
  fixed_ip {
    subnet_id  = openstack_networking_subnet_v2.private_subnet_1.id
    ip_address = var.private_subnet_gateway_ip
  }
}

# Create a router interface to the private network
resource "openstack_networking_router_interface_v2" "private_router_interface" {
  router_id  = openstack_networking_router_v2.router_1.id
  port_id    = openstack_networking_port_v2.private_port_1.id
  depends_on = [openstack_networking_port_v2.private_port_1, openstack_networking_router_v2.router_1]
}