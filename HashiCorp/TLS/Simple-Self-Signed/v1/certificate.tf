# ==============================================================================
#                             SimpleSelf-Signed Certificate
# ==============================================================================

# 1. Генерация приватного ключа
resource "tls_private_key" "project_private_key" {
  algorithm = var.algorithm
  rsa_bits  = var.rsa_bits
}

# 2. Самоподписанный сертификат
resource "tls_self_signed_cert" "project_self_signed_cert" {

  private_key_pem = tls_private_key.project_private_key.private_key_pem

  subject {
    common_name  = var.common_name # DNS имя ArgoCD
    organization = var.organization
  }

  validity_period_hours = var.validity_period_hours # 1 год

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]

  dns_names = var.dns_names
}

output "cert_pem" {
  value = tls_self_signed_cert.project_self_signed_cert.cert_pem
}

output "private_key_pem" {
  value = tls_private_key.project_private_key.private_key_pem
}