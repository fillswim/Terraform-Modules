
# Получить id роли пользователя "admin"
data "openstack_identity_role_v3" "admin" {
  name = "admin"
}

# Вывести id роли пользователя "admin"
output "admin-role-id" {
  value = data.openstack_identity_role_v3.admin.id
}