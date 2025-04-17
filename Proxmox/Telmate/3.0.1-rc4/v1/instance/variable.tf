
variable "start_vmid" {
  default = {
    "prod" = 1000
    "test" = 2000
  }
}

variable "cpu_cores" {
  default = {
    "proxmox1" = 4
    "proxmox2" = 6
    "proxmox3" = 4
    "proxmox4" = 6
  }
}

# Network 
variable "subnet_octet_1" {
  type    = number
  default = 192
}

variable "subnet_octet_2" {
  type    = number
  default = 168
}

variable "subnet_octet_3" {
  type    = number
  default = 2
}

variable "subnet_octet_4" {
  type    = number
  default = 71
}

variable "subnet_mask" {
  type    = number
  default = 24
}

variable "gateway_octet_4" {
  type    = number
  default = 1
}

variable "vlan" {
  type    = number
  default = -1
}

variable "count_vms" {
  type    = number
  default = 1
}

variable "env" {
  type    = string
  default = "test"
}

variable "vm_name" {
  type    = string
  default = "test-ubuntu"
}

variable "proxmox_node" {
  type    = string
  default = "proxmox3"
}

variable "clone_vm_image" {
  type    = string
  default = "ubuntu-22.04-cloud"
}

# type = "serial0"
variable "vga_type" {
  type    = string
  default = "virtio"
}

variable "memory" {
  type    = number
  default = 4096
}

variable "disk_size" {
  type    = number
  default = 50
}

variable "onboot" {
  type    = bool
  default = false
}
