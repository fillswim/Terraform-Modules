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

variable "validity_period_hours" {
  type    = number
  default = 8760 # 1 год
}