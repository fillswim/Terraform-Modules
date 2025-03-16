data "openstack_networking_secgroup_v2" "secgroup" {
  tenant_id = data.openstack_identity_project_v3.project.id
  name      = var.secgroup-name
}
