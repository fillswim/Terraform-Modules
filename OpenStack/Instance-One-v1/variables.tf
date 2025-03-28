# =====================================
#          Параметры истанса
# =====================================

variable "instance-name" {
  type    = string
}

variable "image-name" {
  type    = string
}

variable "flavor-name" {
  type    = string
}

variable "keypair-name" {
  type    = string
  default = "keypair-1"
}

variable "root-volume-size" {
  type    = number
  default = 50
}

# =====================================
#           Параметры сети
# =====================================

variable "private-network-name" {
  type    = string
  default = "private-subnet"
}

variable "security-group-name" {
  type    = string
  default = "default"
}

variable "fixed-ip-v4" {
  type    = string
}

variable "user-data" {
  type    = string
  default = "user_data.yaml"
}
