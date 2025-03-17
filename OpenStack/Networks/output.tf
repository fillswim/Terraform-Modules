
output "details" {
  value = {
    project_name                   = data.openstack_identity_project_v3.project.name
    project_id                     = data.openstack_identity_project_v3.project.id
    private_network_name           = openstack_networking_network_v2.private_network.name
    private_network_id             = openstack_networking_network_v2.private_network.id
    private_subnet_name            = openstack_networking_subnet_v2.private_subnet_1.name
    private_subnet_id              = openstack_networking_subnet_v2.private_subnet_1.id
    private_subnet_cidr            = openstack_networking_subnet_v2.private_subnet_1.cidr
    private_subnet_gateway_ip      = openstack_networking_subnet_v2.private_subnet_1.gateway_ip
    private_subnet_dns_nameservers = openstack_networking_subnet_v2.private_subnet_1.dns_nameservers
  }
}
