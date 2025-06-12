# ================================================
#                  SSH Connection
# ================================================

variable "ssh_private_key" {
  type    = string
  default = "~/.ssh/id_ed25519"
}

variable "ssh_user" {
  type    = string
}

# ================================================
#                    CPU Settings
# ================================================

variable "cpu_cores" {
  default = {
    "proxmox1" = 4
    "proxmox2" = 6
    "proxmox3" = 4
    "proxmox4" = 6
    "proxmox5" = 6
  }
}

# будут ли TRIM/UNMAP команды передаваться из гостевой ОС на уровень хранилища
# Только для local-lvm (LVM-Thin)
variable "discard" {
  default = {
    "local-lvm" = "on"
    "local"     = "ignore"
    "SSD"       = "ignore"
    "HDD"       = "ignore"
  }
}

variable "count_proxmox_nodes" {
  type    = number
  default = 5
}

# ================================================
#                     Image Settings
# ================================================

variable "image_name" {
  type    = string
  default = "noble-server-cloudimg-amd64.img"
}

variable "cloud_init_file_name" {
  type    = string
  default = "user_data.yaml"
}

variable "cloud_init_file_datastore" {
  type    = string
  default = "local"
}

# =============================================
#                     Network
# =============================================

variable "vlan_id" {
  type    = number
  default = 0
}

variable "network_bridge" {
  type    = string
  default = "vmbr0"
}

variable "ip_address" {
  type = string
}

variable "subnet_mask" {
  type    = string
  default = "24"
}

variable "gateway" {
  type    = string
  default = "192.168.2.1"
}

variable "nameservers" {
  type    = list(string)
  default = ["192.168.2.11", "192.168.2.12"]
}

variable "searchdomain" {
  type    = string
  default = "fillswim.local"
}

# ================================================
#                     VM Settings
# ================================================

variable "count_vms" {
  type    = number
  default = 1
}

variable "vm_name" {
  type    = string
  default = "test-ubuntu"
}

variable "proxmox_node" {
  type    = string
  default = "proxmox3"
}

variable "memory" {
  type    = number
  default = 4096
}

variable "on_boot" {
  type    = bool
  default = true
}

variable "agent" {
  type    = bool
  default = true
}

variable "stop_on_destroy" {
  type    = bool
  default = true
}

variable "cpu_type" {
  type    = string
  default = "host"
}

variable "protection" {
  type    = bool
  default = false
}

# ================================================
#                     Root Disks
# ================================================

variable "root_disk_datastore_name" {
  type    = string
  default = "local-lvm"
}

variable "root_disk_size" {
  type    = number
  default = 20
}

variable "root_disk_interface" {
  type    = string
  default = "virtio0"
}

variable "root_disk_iothread" {
  type    = bool
  default = true
}

variable "root_disk_backup" {
  type    = bool
  default = true
}

# ===============================================
#                   Extra Disks
# ===============================================

variable "extra_disks_count" {
  type    = number
  default = 0
}

variable "extra_disks_datastore_name" {
  type    = string
  default = "HDD"
}

variable "extra_disks_size" {
  type    = number
  default = 100
}

variable "extra_disks_interface" {
  type    = string
  default = "virtio"
}

variable "extra_disks_iothread" {
  type    = bool
  default = true
}

variable "extra_disks_backup" {
  type    = bool
  default = true
}

# ===============================================
#                   Node Splitting
# ===============================================

variable "node_splitting" {
  type    = bool
  default = false
}