variable "start_vmid" {
  default = {
    "prod" = 1000
    "test" = 2000
  }
}

variable "cpu_cores" {
  default = {
    "proxmox2" = 6
    "proxmox4" = 6
    "proxmox5" = 6
  }
}

variable "count_vms" {
  default = 1
}

variable "ip" {
  default = 71
}

variable "env" {
  default = "test"
}

variable "vm_name" {
  default = "test-ubuntu"
}

variable "proxmox_node" {
  default = "proxmox2"
}

variable "clone_vm_image" {
  default = "redos-7.3.4-cloud"
}

variable "memory" {
  default = 4096
}

variable "disk_size" {
  default = "50"
}
