variable "algorithm" {
  type    = string
  default = "RSA"
}

variable "rsa_bits" {
  type    = number
  default = 2048
}

# domain name
variable "common_name" {
  type    = string
}

# "My Organization"
variable "organization" {
  type    = string
}

# domain name
variable "dns_names" {
  type    = list(string)
}

# Закрытый ключ Центра Сертификации (CA)
# ca_private_key_pem = tls_private_key.ca_private_key.private_key_pem
# file("../CA-Certificate/.certs/ca.key")
variable "ca_private_key_pem" {
  type    = string
}

# Сертификат Центра Сертификации (CA)
# ca_cert_pem = tls_self_signed_cert.ca_self_signed_cert.cert_pem
# file("../CA-Certificate/.certs/ca.crt")
variable "ca_cert_pem" {
  type    = string
}

# Срок действия (в часах)
variable "validity_period_hours" {
  type    = number
  default = 8760
}