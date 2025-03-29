variable "tenant_name" {
  type = string
}

variable "private_network_name" {
  type    = string
  default = "private-network"
}

variable "private_subnet_name" {
  type    = string
  default = "private-subnet-1"
}

variable "port_name" {
  type = string
}

variable "port_ip_address" {
  type = string
}

variable "instance_id" {
  type = string
}
