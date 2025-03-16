
variable "project-name" {
  description = "Имя проекта"
  type        = string
}

variable "private_subnet_cidr" {
  type = string
}

variable "private_subnet_dns_nameservers" {
  type    = list(string)
  default = ["192.168.2.11", "192.168.2.12"]
}

variable "private_subnet_gateway_ip" {
  type = string
}

variable "external_fixed_ip_ip_address" {
  type = string
}

variable "public_network_name" {
  type    = string
  default = "public"
}

variable "public_subnet_name" {
  type    = string
  default = "public-subnet"
}

variable "ssh_keypair_1_name" {
  type    = string
  default = "keypair-1"
}

variable "ssh_public_key_1" {
  type = string
}

variable "private_network_name" {
  type    = string
  default = "private-subnet"
}

variable "secgroup_name" {
  type    = string
  default = "secgroup-1"
}

variable "router_name" {
  type    = string
  default = "router-1"
}

variable "private_port_1_name" {
  type    = string
  default = "private-port-1"
}

variable "private_subnet_name" {
  type    = string
  default = "private-subnet"
}
