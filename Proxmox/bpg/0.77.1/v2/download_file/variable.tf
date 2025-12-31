# variable "count_proxmox_nodes" {
#   type    = number
#   default = 5
# }

variable "image_url" {
  type    = string
}

variable "image_name" {
  type    = string
}

variable "image_datastore" {
  type    = string
  default = "local"
}

variable "image_type" {
  type    = string
}

variable "proxmox_node_name" {
  type    = string
}
