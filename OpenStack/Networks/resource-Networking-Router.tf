
# Create a router
resource "openstack_networking_router_v2" "router_1" {
  tenant_id           = data.openstack_identity_project_v3.project.id
  name                = var.router_name
  admin_state_up      = true
  external_network_id = data.openstack_networking_network_v2.public_network.id
  external_fixed_ip {
    subnet_id  = data.openstack_networking_subnet_v2.public_subnet.id
    ip_address = var.external_fixed_ip_ip_address
  }
}
