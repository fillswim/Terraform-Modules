
resource "openstack_compute_quotaset_v2" "quotaset" {
  project_id           = openstack_identity_project_v3.project.id
  key_pairs            = 10
  ram                  = 40960
  cores                = 32
  instances            = 30
  server_groups        = 4
  server_group_members = 8
}