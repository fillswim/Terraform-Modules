
resource "openstack_identity_project_v3" "project" {
  name        = var.project_name
  description = "A project created by Terraform"
}