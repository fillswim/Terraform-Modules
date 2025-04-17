locals {
  subnet = "${var.subnet_octet_1}.${var.subnet_octet_2}.${var.subnet_octet_3}"
}

resource "proxmox_vm_qemu" "server" {

  # Количество
  count = var.count_vms

  # 1000 - prod
  # 2000 - test
  vmid = var.env == "prod" ? 10000 * var.subnet_octet_3 + (var.start_vmid["prod"] + var.subnet_octet_4 + count.index) : 10000 * var.subnet_octet_3 + (var.start_vmid["test"] + var.subnet_octet_4 + count.index)

  # Нода Proxmox, на которой будут разворачиваться ВМ-ки
  target_node = var.proxmox_node
  # Название ВМ-ок
  name = "${var.vm_name}-${count.index + 1}"
  # Описание
  desc = "${var.vm_name}-${count.index + 1}"

  # Клонируемый образ ВМ
  clone = var.clone_vm_image

  # Следует ли запускать виртуальную машину после запуска узла PVE
  onboot = var.onboot

  # VM Cloud-Init Settings
  os_type = "cloud-init"

  # Включить гостевой агент
  agent = 1

  # Настройки CPU
  cores   = var.cpu_cores[var.proxmox_node]
  sockets = 1
  cpu     = "host"

  # Настройки оперативная память
  memory = var.memory

  # Тип контроллера SCSI для эмуляции 
  # (lsi, lsi53c810, megasas, pvscsi, virtio-scsi-pci, virtio-scsi-single)
  scsihw = "virtio-scsi-pci"
  # Разрешить загрузку с ide0
  bootdisk = "ide0"
  # Порядок загрузки
  boot = "order=virtio0;ide0;net0"

  # Диски
  disks {
    virtio {
      virtio0 {
        disk {
          storage = "local-lvm"
          size    = var.disk_size
        }
      }
    }
    ide {
      ide0 {
        cloudinit {
          storage = "local-lvm"
        }
      }
    }
  }

  vga {
    type = var.vga_type
  }

  # Конфигурация сети
  network {
    model  = "virtio"
    bridge = "vmbr0"
    tag    = var.vlan
  }

  # Настройки IP и шлюза
  ipconfig0 = "ip=${local.subnet}.${var.subnet_octet_4 + count.index}/${var.subnet_mask},gw=${local.subnet}.${var.gateway_octet_4}"

  lifecycle {
    # prevent_destroy = true
    ignore_changes = [onboot, boot, bootdisk, ciuser, qemu_os, sshkeys]
  }

}

output "details" {
  value = join("\n\n", [
    for vm in proxmox_vm_qemu.server : join("\n", [
      format("VM:           %s", vm.name),
      format("  Node:       %s", vm.target_node),
      format("  ID:         %d", vm.vmid),
      format("  Name:       %s", vm.name),
      format("  Onboot:     %t", vm.onboot),
      format("  Clone:      %s", vm.clone),
      format("  CPU:        %s", vm.cores),
      format("  Memory:     %d MB", vm.memory),
      format("  IPConfig0:  %s", vm.ipconfig0),
    ])
  ])
}
