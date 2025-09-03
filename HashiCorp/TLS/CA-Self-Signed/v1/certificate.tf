# 1. Генерируем приватный ключ для конечного сертификата
resource "tls_private_key" "project_private_key" {
  algorithm = var.algorithm
  rsa_bits  = var.rsa_bits
}

# 2. Создаём CSR для конечного сертификата
resource "tls_cert_request" "project_cert_request" {

  private_key_pem = tls_private_key.project_private_key.private_key_pem

  subject {
    common_name  = var.common_name
    organization = var.organization
  }

  dns_names = var.dns_names

}

# 3. Подписываем CSR для конечного сертификата с помощью CA
resource "tls_locally_signed_cert" "project_locally_signed_cert" {

  # Закрытый ключ Центра Сертификации (CA)
  # ca_private_key_pem = tls_private_key.ca_private_key.private_key_pem
  # ca_private_key_pem = file("../CA-Certificate/.certs/ca.key")
  ca_private_key_pem = var.ca_private_key_pem

  # Сертификат Центра Сертификации (CA)
  # ca_cert_pem = tls_self_signed_cert.ca_self_signed_cert.cert_pem
  # ca_cert_pem = file("../CA-Certificate/.certs/ca.crt")
  ca_cert_pem = var.ca_cert_pem

  # Запрос сертификата
  cert_request_pem = tls_cert_request.project_cert_request.cert_request_pem

  # Срок действия (в часах)
  validity_period_hours = 8760

  # Разрешенные использования
  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

output "cert_pem" {
  value = tls_locally_signed_cert.project_locally_signed_cert.cert_pem
}

output "private_key_pem" {
  value = tls_private_key.project_private_key.private_key_pem
}