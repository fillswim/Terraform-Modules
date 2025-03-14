
resource "openstack_identity_user_v3" "user" {
  default_project_id = openstack_identity_project_v3.project.id
  name               = var.user_name
  description        = "Project user created by Terraform"

  password = var.user_password
}