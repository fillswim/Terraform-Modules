
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

# =============================================
#                     Network
# =============================================

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
  default = 0
}

variable "network_model" {
  type    = string
  default = "virtio"
}

variable "network_bridge" {
  type    = string
  default = "vmbr0"
}

variable "nameserver" {
  type    = string
  default = "192.168.2.11 192.168.2.12"
}

variable "searchdomain" {
  type    = string
  default = "fillswim.local"
}

# ================================================
#                     VM-s
# ================================================

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
  default = "proxmox5"
}

variable "clone_vm_image" {
  type    = string
  default = "ubuntu-22.04-cloud"
}

variable "memory" {
  type    = number
  default = 4096
}

variable "onboot" {
  type    = bool
  default = false
}

# type = "serial0"
variable "vga_type" {
  type    = string
  default = "virtio" # Ubuntu
}

# ================================================
#                     Disks
# ================================================

variable "scsihw" {
  type    = string
  default = "virtio-scsi-pci" # Ubuntu
}

variable "bootdisk" {
  type    = string
  default = "ide0"
}

variable "boot_order" {
  type    = string
  default = "order=virtio0;ide0;net0" # Ubuntu
}

variable "cloudinit_disk_slot" {
  type    = string
  default = "ide0"
}

variable "cloudinit_disk_type" {
  type    = string
  default = "cloudinit"
}

variable "cloudinit_disk_storage" {
  type    = string
  default = "local-lvm"
}

variable "disk_slot" {
  type    = string
  default = "virtio0" # Ubuntu
}

variable "disk_type" {
  type    = string
  default = "disk"
}

variable "disk_storage" {
  type    = string
  default = "local-lvm"
}

variable "disk_size" {
  type    = number
  default = 50
}

variable "disk_format" {
  type    = string
  default = "raw"
}

# ===============================================
#                   Extra Disks
# ===============================================

variable "extra_disks_count" {
  type    = number
  default = 0
}

variable "extra_disks_size" {
  type    = number
  default = 100
}

variable "extra_disks_type" {
  type    = string
  default = "disk"
}

variable "extra_disks_slot_type" {
  type    = string
  default = "scsi"
}

variable "extra_disks_storage" {
  type    = string
  default = "HDD"
}

variable "extra_disks_format" {
  type    = string
  default = "raw"
}

# ===============================================
#                   Fixed VMID
# ===============================================

variable "fixed_vmid" {
  type    = number
  default = 0
}

variable "fixed_name" {
  type    = string
  default = ""
}

# ===============================================
#                   Node Splitting
# ===============================================

variable "node_splitting" {
  type    = bool
  default = false
}
