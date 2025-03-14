
# Create a private network
resource "openstack_networking_network_v2" "private_network" {
  name           = var.private_network_name
  admin_state_up = "true"
}