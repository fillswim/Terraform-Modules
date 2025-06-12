
# terraform destroy --target=proxmox_virtual_environment_vm.ubuntu_vm

resource "proxmox_virtual_environment_file" "cloud_config" {
  count        = local.count_proxmox_nodes
  node_name    = "proxmox${1 + count.index}"
  datastore_id = var.cloud_init_file_datastore
  content_type = "snippets"
  source_file {
    path      = var.cloud_init_file_name
    file_name = local.full_user_data_file_name
  }
}

locals {

  # Количество proxmox серверов
  count_proxmox_nodes = var.count_proxmox_nodes

  ip_address  = var.ip_address
  subnet_mask = var.subnet_mask

  # ip_address_test = "192.168.2.235/24"
  # # Вывод: "192.168.2.235"
  # ip_address_without_mask = split("/", local.ip_address_test)[0]
  # # Выводы по октетам:
  # # Вывод: "192"
  # ip_address_test_octet_1 = split(".", local.ip_address_without_mask)[0]
  # # Вывод: "168"
  # ip_address_test_octet_2 = split(".", local.ip_address_without_mask)[1]
  # # Вывод: "2"
  # ip_address_test_octet_3 = split(".", local.ip_address_without_mask)[2]
  # # Вывод: "235"
  # ip_address_test_octet_4 = split(".", local.ip_address_without_mask)[3]

  # разделение IP-адреса на части
  ip_address_part    = split(".", local.ip_address)
  ip_address_octet_4 = local.ip_address_part[3]
  # формирование ID виртуальной машины
  vm_id_start = ( local.ip_address_part[1] * 1000000 +
                  local.ip_address_part[2] * 1000 +
                  local.ip_address_part[3] )

  # для IP-адреса в блоке ip_config
  ip_address_and_mask = join("/", [local.ip_address, local.subnet_mask])

  # Формирование имени файла user_data.yaml на сервере Proxmox ("user_data_vmid.yaml"):
  # join("_", ["user_data", local.vm_id_start]) = "user_data_235"
  user_data_file_name = join("_", ["user_data", local.vm_id_start])
  # join(".", [local.user_data_file_name, "yaml"]) = "user_data_235.yaml"
  full_user_data_file_name = join(".", [local.user_data_file_name, "yaml"])

  # Путь для cloud-init диска ("local:iso/noble-server-cloudimg-amd64.img"):
  # join(":", [var.cloud_init_file_datastore, "iso"]) = "local:iso"
  iso_datastore_path = join(":", [var.cloud_init_file_datastore, "iso"])
  # join("/", [local.iso_datastore_path, var.image_name]) = "local:iso/noble-server-cloudimg-amd64.img"
  image_path = join("/", [local.iso_datastore_path, var.image_name])

  # Добавление дополнительных дисков
  # Генерация списка из объектов с дисками [{}, {}, {}]
  extra_disks = [
    for i in range(var.extra_disks_count) : {
      datastore_id = var.extra_disks_datastore_name
      size         = var.extra_disks_size
      interface    = "${var.extra_disks_interface}${i + 1}"
      iothread     = var.extra_disks_iothread
      discard      = var.discard[var.extra_disks_datastore_name]
      backup       = var.extra_disks_backup
    }
  ]

}

resource "proxmox_virtual_environment_vm" "instance" {

  count = var.count_vms

  name = "${var.vm_name}-${count.index + 1}"
  # node_name = var.proxmox_node
  # деление индекса вм-ки по модулю 5 (количество proxmox серверов) + 1
  node_name = var.node_splitting ? "proxmox${count.index % local.count_proxmox_nodes + 1}" : var.proxmox_node

  # формирование ID виртуальной машины
  #                    cidrhost(local.ip_address_and_mask, local.ip_address_octet_4 + count.index)     = "192.168.50.235"
  #         split(".", cidrhost(local.ip_address_and_mask, local.ip_address_octet_4 + count.index))[3] = "235"
  vm_id = ( split(".", cidrhost(local.ip_address_and_mask, local.ip_address_octet_4 + count.index))[1] * 1000000 +
            split(".", cidrhost(local.ip_address_and_mask, local.ip_address_octet_4 + count.index))[2] * 1000 +
            split(".", cidrhost(local.ip_address_and_mask, local.ip_address_octet_4 + count.index))[3] )

  # should be true if qemu agent is not installed / enabled on the VM
  stop_on_destroy = var.stop_on_destroy

  agent {
    enabled = var.agent
  }

  cpu {
    cores = var.cpu_cores[var.proxmox_node]
    type  = var.cpu_type
  }

  memory {
    dedicated = var.memory
  }

  on_boot    = var.on_boot
  protection = var.protection

  initialization {

    # user_data_file_id = proxmox_virtual_environment_file.cloud_config.id
    # count.index % local.count_proxmox_nodes = [0, 1, 2, 3, 4]
    user_data_file_id = proxmox_virtual_environment_file.cloud_config[count.index % local.count_proxmox_nodes].id

    ip_config {
      ipv4 {
        #                    cidrhost(local.ip_address_and_mask, local.ip_address_octet_4 + count.index)                      = "192.168.50.235"
        #         join("/", [cidrhost(local.ip_address_and_mask, local.ip_address_octet_4 + count.index), local.subnet_mask]) = "192.168.50.235/24"
        address = join("/", [cidrhost(local.ip_address_and_mask, local.ip_address_octet_4 + count.index), local.subnet_mask])
        gateway = var.gateway
      }
    }

    dns {
      servers = var.nameservers
      domain  = var.searchdomain
    }

  }

  # root disk
  disk {
    datastore_id = var.root_disk_datastore_name
    file_id      = local.image_path
    size         = var.root_disk_size
    interface    = var.root_disk_interface
    iothread     = var.root_disk_iothread
    discard      = var.discard[var.root_disk_datastore_name]
    backup       = var.root_disk_backup
  }

  # Extra Disks
  # Обход в цикле списка с объектами дисков
  dynamic "disk" {
    for_each = local.extra_disks
    content {
      datastore_id = disk.value.datastore_id
      size         = disk.value.size
      interface    = disk.value.interface
      iothread     = disk.value.iothread
      discard      = disk.value.discard
      backup       = disk.value.backup
    }
  }

  network_device {
    bridge  = var.network_bridge
    vlan_id = var.vlan_id
  }
}

# Переименовать hostname
resource "null_resource" "remote_exec" {

  depends_on = [proxmox_virtual_environment_vm.instance]

  count = var.count_vms

  provisioner "remote-exec" {

    connection {
      type        = "ssh"
      host        = cidrhost(local.ip_address_and_mask, local.ip_address_octet_4 + count.index)
      user        = var.ssh_user
      private_key = file(var.ssh_private_key)
    }

    inline = [
      "sudo hostnamectl set-hostname ${var.vm_name}-${count.index + 1}"
    ]
  }

}


output "details" {
  value = join("\n\n", [
    for vm in proxmox_virtual_environment_vm.instance : join("\n", [
      format("VM:            %s", vm.name),
      format("  VM ID:       %d", vm.vm_id),
      format("  Image:       %s", vm.disk[0].file_id),
      format("  VLAN ID:     %d", vm.network_device[0].vlan_id),
      format("  IP:          %s", vm.initialization[0].ip_config[0].ipv4[0].address),
      format("  Gateway:     %s", vm.initialization[0].ip_config[0].ipv4[0].gateway),
      format("  DNS Domain:  %s", vm.initialization[0].dns[0].domain),
      format("  DNS Servers: %s", join(", ", vm.initialization[0].dns[0].servers)),
      format("  Node:        %s", vm.node_name),
      format("  Onboot:      %t", vm.on_boot),
      format("  CPU:         %s", vm.cpu[0].cores),
      format("  Memory:      %d MB", vm.memory[0].dedicated),
      format("  Protection:  %s", vm.protection),
      format("  Count Disks: %s", length(vm.disk)),
    ])
  ])
}
