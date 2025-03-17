
output "details" {
  value = {
    project_name      = openstack_identity_project_v3.project.name
    project_id        = openstack_identity_project_v3.project.id
    project_user_name = openstack_identity_user_v3.user.name
    project_user_id   = openstack_identity_user_v3.user.id
  }
}
