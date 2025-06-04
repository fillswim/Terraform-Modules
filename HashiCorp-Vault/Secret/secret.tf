# ================================== Policies ==================================

# Добавить полилитику
resource "vault_policy" "policy" {
  name   = var.vault_policy_name
  policy = file(var.vault_policy_file)
}

# ================================== Folders ===================================

# Включить механизм KV2 для папки
resource "vault_mount" "folder" {
  path        = var.vault_mount_path
  type        = var.vault_mount_type
  description = var.vault_mount_description
}

# ==================================== Roles ===================================

# Создание роли для доступа к секрету 
resource "vault_kubernetes_auth_backend_role" "role" {
  # backend                          = data.terraform_remote_state.remote_state.outputs.vault_auth_backend_kubernetes_path
  backend                          = var.vault_role_backend
  role_name                        = var.vault_role_name
  bound_service_account_names      = var.vault_role_bound_service_account_names
  bound_service_account_namespaces = var.vault_role_bound_service_account_namespaces
  token_ttl                        = var.vault_role_token_ttl
  token_policies                   = ["default", vault_policy.policy.name]
  audience                         = var.vault_role_audience
}

# =================================== Secret ===================================

# Создать секрет
resource "vault_generic_secret" "secret" {
  path      = "${vault_mount.folder.path}/${var.vault_secret_name}"
  data_json = file(var.vault_secret_file)
}

output "details" {
  value = join("\n", [
    format("==========================================================================="),
    format("                                  Folder                                   "),
    format("==========================================================================="),
    format("Path:                                 %s", vault_mount.folder.path),
    format("Type:                                 %s", vault_mount.folder.type),
    format("==========================================================================="),
    format("                                  Policy                                   "),
    format("==========================================================================="),
    format("Policy name:                          %s", vault_policy.policy.name),
    format("Policy details:                       %s", vault_policy.policy.policy),
    format("==========================================================================="),
    format("                                   Role                                    "),
    format("==========================================================================="),
    format("Role Name:                            %s", vault_kubernetes_auth_backend_role.role.role_name),
    format("Backend:                              %s", vault_kubernetes_auth_backend_role.role.backend),
    format("Audience:                             %s", vault_kubernetes_auth_backend_role.role.audience),
    format("Token Policies:                       %s", join(", ", vault_kubernetes_auth_backend_role.role.token_policies)),
    format("Bound Service Account Names:          %s", join(", ", vault_kubernetes_auth_backend_role.role.bound_service_account_names)),
    format("Bound Service Account Namespaces:     %s", join(", ", vault_kubernetes_auth_backend_role.role.bound_service_account_namespaces)),
    format("==========================================================================="),
    format("                                  Secret                                   "),
    format("==========================================================================="),
    format("Path:                                 %s", vault_generic_secret.secret.path),
    format("==========================================================================="),
  ])
}
