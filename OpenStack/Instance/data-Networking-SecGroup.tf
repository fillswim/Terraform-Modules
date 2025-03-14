data "openstack_networking_secgroup_v2" "secgroup" {
  name = var.secgroup-name
}

output "secgroup_id" {
  value = data.openstack_networking_secgroup_v2.secgroup.id
}
