# Terraform-Modules

## Instance

### v1

### v2
Добавлен перебор по узлам proxmox.

```tf
variable "proxmox_node_names" {
  type    = list(string)
  default = ["proxmox2", "proxmox4", "proxmox5"]
}
```

## Download file

### v1

### v2

Убран:
```tf
variable "count_proxmox_nodes" {
  type    = number
  default = 5
}
```
Заменен на:
```tf
variable "proxmox_node_name" {
  type    = string
}
```

