# ==============================================================================
#                                Получение Tenant ID
# ==============================================================================

data "openstack_identity_project_v3" "tenant" {
  name = var.tenant_name
}

# Вывод Tenant ID
output "tenant_id" {
  value = data.openstack_identity_project_v3.tenant.id
}

# ==============================================================================
#                          Получение Private Network ID
# ==============================================================================

# Получение ID приватной сети
data "openstack_networking_network_v2" "private_network" {
  name = var.private_network_name
}

# Вывод ID приватной сети
output "private_network_id" {
  value = data.openstack_networking_network_v2.private_network.id
}

# ==============================================================================
#                         Получение Private Subnet ID
# ==============================================================================

# Получение ID приватной подсети
data "openstack_networking_subnet_v2" "private_subnet" {
  name       = var.private_subnet_name
  network_id = data.openstack_networking_network_v2.private_network.id
}

# Вывод ID приватной подсети
output "private_subnet_id" {
  value = data.openstack_networking_subnet_v2.private_subnet.id
}

# ==============================================================================
#            Создать порт на приватной сети для подключения sys-adm
# ==============================================================================

resource "openstack_networking_port_v2" "private_port_to_Ansible_host" {
  name           = var.port_name
  tenant_id      = data.openstack_identity_project_v3.tenant.id
  network_id     = data.openstack_networking_network_v2.private_network.id
  admin_state_up = true
  fixed_ip {
    subnet_id  = data.openstack_networking_subnet_v2.private_subnet.id
    ip_address = var.port_ip_address
  }
}

# ==============================================================================
#                     Прикрепить порт к виртуальной машине
# ==============================================================================

resource "openstack_compute_interface_attach_v2" "interface_attach" {
  instance_id = var.instance_id
  port_id     = openstack_networking_port_v2.private_port_to_Ansible_host.id
}


