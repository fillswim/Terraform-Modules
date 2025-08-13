# Terraform-Modules

## Instance

### v1

### v2
Добавлен перебор по узлам proxmox.

```terraform
variable "proxmox_node_names" {
  type    = list(string)
  default = ["proxmox2", "proxmox4", "proxmox5"]
}