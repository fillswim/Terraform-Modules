locals {

  ip_address  = var.ip_address
  subnet_mask = var.subnet_mask

  # разделение IP-адреса на части
  ip_address_part    = split(".", local.ip_address)
  ip_address_octet_4 = local.ip_address_part[3]

  # для IP-адреса в блоке ip_config
  ip_address_and_mask = join("/", [local.ip_address, local.subnet_mask])

  # Добавление дополнительных дисков
  # Генерация списка из объектов с дисками [{}, {}, {}]
  extra_disks = [
    for key, path in var.extra_disks_mount_path : {
      volume = var.extra_disks_datastore_name
      size   = var.extra_disks_size
      path   = path
      backup = var.extra_disks_backup
    }
  ]

}

resource "proxmox_virtual_environment_container" "lxc" {

  count = var.count_lxcs

  # деление индекса вм-ки по модулю 5 (количество proxmox серверов) + 1
  node_name = var.node_splitting ? "proxmox${count.index % var.count_proxmox_nodes + 1}" : var.proxmox_node

  # формирование ID виртуальной машины
  #                    cidrhost(local.ip_address_and_mask, local.ip_address_octet_4 + count.index)     = "192.168.50.235"
  #         split(".", cidrhost(local.ip_address_and_mask, local.ip_address_octet_4 + count.index))[3] = "235"
  vm_id = ( split(".", cidrhost(local.ip_address_and_mask, local.ip_address_octet_4 + count.index))[1] * 1000000 +
            split(".", cidrhost(local.ip_address_and_mask, local.ip_address_octet_4 + count.index))[2] * 1000 +
            split(".", cidrhost(local.ip_address_and_mask, local.ip_address_octet_4 + count.index))[3] )

  cpu {
    cores        = var.cpu_cores[var.proxmox_node]
    architecture = var.cpu_architecture
    units        = var.cpu_units
  }

  memory {
    dedicated = var.memory
  }

  protection    = var.protection
  start_on_boot = var.start_on_boot

  # root disk
  disk {
    datastore_id = var.root_disk_datastore_name
    size         = var.root_disk_size
  }

  network_interface {
    name    = var.network_interface_name
    bridge  = var.network_bridge
    vlan_id = var.vlan_id
  }

  dynamic "mount_point" {
    for_each = local.extra_disks
    content {
      volume = mount_point.value.volume
      size   = mount_point.value.size
      path   = mount_point.value.path
      backup = mount_point.value.backup
    }
  }

  initialization {

    hostname = "${var.lxc_name}-${count.index + 1}"

    ip_config {
      ipv4 {
        #                    cidrhost(local.ip_address_and_mask, local.ip_address_octet_4 + count.index)                      = "192.168.50.235"
        #         join("/", [cidrhost(local.ip_address_and_mask, local.ip_address_octet_4 + count.index), local.subnet_mask]) = "192.168.50.235/24"
        address = join("/", [cidrhost(local.ip_address_and_mask, local.ip_address_octet_4 + count.index), local.subnet_mask])
        gateway = var.gateway
      }
    }

    user_account {
      keys     = var.lxc_ssh_public_keys
      password = var.lxc_password
    }

    dns {
      servers = var.nameservers
      domain  = var.searchdomain
    }

  }

  console {
    enabled = var.console_enabled
    type    = var.console_type
  }

  features {
    nesting = var.features_nesting
  }

  unprivileged = var.unprivileged

  operating_system {

    template_file_id = var.lxc_templates[var.lxc_template_distribution]
    type             = var.lxc_type[var.lxc_template_distribution]

  }

}

# Конфигурирование контейнера
# Запускается только для centos
resource "null_resource" "remote_exec" {

  depends_on = [proxmox_virtual_environment_container.lxc]

  # Запускается только для centos
  count = var.lxc_type[var.lxc_template_distribution] == "centos" ? var.count_lxcs : 0

  # Запускается на удаленном сервере Proxmox
  provisioner "remote-exec" {
    inline = [
      "apt install -y mtr",
      "pct exec ${proxmox_virtual_environment_container.lxc[count.index].vm_id} -- dnf update -y",
      "pct exec ${proxmox_virtual_environment_container.lxc[count.index].vm_id} -- dnf install -y openssh-server",
      "pct exec ${proxmox_virtual_environment_container.lxc[count.index].vm_id} -- systemctl enable sshd",
      "pct exec ${proxmox_virtual_environment_container.lxc[count.index].vm_id} -- systemctl start sshd"
    ]

    connection {
      type        = "ssh"
      user        = var.proxmox_node_ssh_username
      private_key = file(var.proxmox_node_ssh_private_key_file)
      host        = var.proxmox_node_ip_address[proxmox_virtual_environment_container.lxc[count.index].node_name]
    }
  }
}

output "details" {
  value = join("\n\n", [
    for lxc in proxmox_virtual_environment_container.lxc : join("\n", [
      format("LXC:           %s", lxc.initialization[0].hostname),
      format("  LXC ID:      %d", lxc.vm_id),
      format("  Image:       %s", lxc.operating_system[0].template_file_id),
      format("  VLAN ID:     %d", lxc.network_interface[0].vlan_id),
      format("  IP:          %s", lxc.initialization[0].ip_config[0].ipv4[0].address),
      format("  Gateway:     %s", lxc.initialization[0].ip_config[0].ipv4[0].gateway),
      format("  DNS Domain:  %s", lxc.initialization[0].dns[0].domain),
      format("  DNS Servers: %s", join(", ", lxc.initialization[0].dns[0].servers)),
      format("  Node:        %s", lxc.node_name),
      format("  Onboot:      %t", lxc.start_on_boot),
      format("  CPU Units:   %s", lxc.cpu[0].units),
      format("  CPU Cores:   %s", lxc.cpu[0].cores),
      format("  Memory:      %d MB", lxc.memory[0].dedicated),
      format("  Protection:  %s", lxc.protection),
      format("  Count Disks: %s", length(lxc.mount_point)),
    ])
  ])
}