
# Найти проект по имени
data "openstack_identity_project_v3" "project" {
  name = var.project-name
}

# Выводим id проекта
output "project_id" {
  value = data.openstack_identity_project_v3.project.id
}