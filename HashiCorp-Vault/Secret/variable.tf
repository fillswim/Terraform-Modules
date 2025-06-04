# ==========================================
#                Vault Policy
# ==========================================

variable "vault_policy_name" {
  type    = string
}

variable "vault_policy_file" {
  type    = string
}

# ==========================================
#        Папка c секретами в Vault
# ==========================================

variable "vault_mount_path" {
  type    = string
}

variable "vault_mount_type" {
  type    = string
}

variable "vault_mount_description" {
  type    = string
}

# ==========================================
#                    Role
# ==========================================

variable "vault_role_name" {
  type    = string
}

variable "vault_role_backend" {
  type    = string
  default = "kubernetes"
}

variable "vault_role_bound_service_account_names" {
  type    = list(string)
  default = ["default"]
}

variable "vault_role_bound_service_account_namespaces" {
  type    = list(string)
}

variable "vault_role_token_ttl" {
  type    = number
  default = 86400 # 24 часа
}

variable "vault_role_audience" {
  type    = string
  default = "vault"
}

# ==========================================
#                   Secret
# ==========================================

variable "vault_secret_name" {
  type    = string
}

variable "vault_secret_file" {
  type    = string
}