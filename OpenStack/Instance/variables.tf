
variable "instance-name" {
  type = string
}

variable "admin-password" {
  type = string
}

variable "instance-ip-v4" {
  type = string
}

variable "floating-ip-v4" {
  type = string
}

variable "flavor-name" {
  type    = string
  default = "m1.medium"
}

variable "keypair-name" {
  type    = string
  default = "keypair-1"
}

variable "image-name" {
  type    = string
  default = "Ubuntu 24.04 LTS"
}

variable "private-network-name" {
  type    = string
  default = "private-subnet"
}

variable "public-network-name" {
  type    = string
  default = "public"
}

variable "secgroup-name" {
  type    = string
  default = "secgroup-1"
}

