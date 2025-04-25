locals {
  subnet = "${var.subnet_octet_1}.${var.subnet_octet_2}.${var.subnet_octet_3}"
  extra_disks = [
    for i in range(var.extra_disks_count) : {
      slot    = "${var.extra_disks_slot_type}${i+1}"
      type    = var.extra_disks_type
      storage = var.extra_disks_storage
      size    = var.extra_disks_size
      format  = var.extra_disks_format
    }
  ]
}

resource "proxmox_vm_qemu" "server" {

  # Количество
  count = var.count_vms

  # 1000 - prod
  # 2000 - test
  # vmid = var.env == "prod" ? 10000 * var.subnet_octet_3 + (var.start_vmid["prod"] + var.subnet_octet_4 + count.index) : 10000 * var.subnet_octet_3 + (var.start_vmid["test"] + var.subnet_octet_4 + count.index)
  
  # Если fixed_vmid не 0, то используем его, иначе используем расчет по env
  vmid = var.fixed_vmid != 0 ? var.fixed_vmid + count.index : 10000 * var.subnet_octet_3 + (var.start_vmid[var.env] + var.subnet_octet_4 + count.index)

  # Нода Proxmox, на которой будут разворачиваться ВМ-ки
  target_node = var.proxmox_node
  # Название ВМ-ок
  # name = "${var.vm_name}-${count.index + 1}"
  name = var.fixed_name != "" ? var.fixed_name : "${var.vm_name}-${count.index + 1}"
  # Описание
  # desc = "${var.vm_name}-${count.index + 1}"
  desc = var.fixed_name != "" ? var.fixed_name : "${var.vm_name}-${count.index + 1}"

  # Клонируемый образ ВМ
  clone = var.clone_vm_image

  # Следует ли запускать виртуальную машину после запуска узла PVE
  onboot = var.onboot

  # VM Cloud-Init Settings
  os_type = "cloud-init"

  # Включить гостевой агент
  agent = 1

  # Настройки CPU
  cores    = var.cpu_cores[var.proxmox_node]
  sockets  = 1
  cpu_type = "host"

  # Настройки оперативная память
  memory = var.memory

  # Тип контроллера SCSI для эмуляции 
  # (lsi, lsi53c810, megasas, pvscsi, virtio-scsi-pci, virtio-scsi-single)
  scsihw = var.scsihw
  # Разрешить загрузку с ide0
  bootdisk = var.bootdisk
  # Порядок загрузки
  boot = var.boot_order

  # Cloud-Init Disk
  disk {
    slot    = var.cloudinit_disk_slot
    type    = var.cloudinit_disk_type
    storage = var.cloudinit_disk_storage
  }

  # Main Disk
  disk {
    slot    = var.disk_slot
    type    = var.disk_type
    size    = var.disk_size
    storage = var.disk_storage
    format  = var.disk_format
  }

  # Extra Disks
  dynamic "disk" {
    for_each = local.extra_disks
    content {
      slot    = disk.value.slot
      type    = disk.value.type
      storage = disk.value.storage
      size    = disk.value.size
      format  = disk.value.format
    }
  }

  # VGA
  vga {
    type = var.vga_type
  }

  # Конфигурация сети
  network {
    id     = 0
    model  = var.network_model
    bridge = var.network_bridge
    tag    = var.vlan
  }

  # Настройки IP и шлюза
  ipconfig0    = "ip=${local.subnet}.${var.subnet_octet_4 + count.index}/${var.subnet_mask},gw=${local.subnet}.${var.gateway_octet_4}"
  nameserver   = var.nameserver
  searchdomain = var.searchdomain

  lifecycle {
    prevent_destroy = true
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
