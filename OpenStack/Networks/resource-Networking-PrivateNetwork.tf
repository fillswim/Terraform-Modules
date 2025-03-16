
# Create a private network
resource "openstack_networking_network_v2" "private_network" {
  tenant_id      = data.openstack_identity_project_v3.project.id
  name           = var.private_network_name
  admin_state_up = "true"
}