# Создать инстанс
resource "openstack_compute_instance_v2" "instance" {
  count           = var.instance-count
  name            = "${var.instance-name-prefix}-${count.index + 1}" # Имя инстанса будет состоять из имени, указанного в переменной, и номера инстанса
  image_id        = data.openstack_images_image_v2.image.id
  flavor_id       = data.openstack_compute_flavor_v2.m1_medium.id
  key_pair        = data.openstack_compute_keypair_v2.keypair_1.id
  security_groups = [data.openstack_networking_secgroup_v2.secgroup.name]
  admin_pass      = var.admin-password

  network {
    uuid        = data.openstack_networking_network_v2.private_network.id
    fixed_ip_v4 = cidrhost(data.openstack_networking_subnet_v2.private_subnet.cidr, var.starting-host-number + count.index)
  }
}

output "name" {
  description = "Names of the instances"
  value       = openstack_compute_instance_v2.instance[*].name
}

output "ip" {
  description = "IP addresses of the instances"
  value       = openstack_compute_instance_v2.instance[*].network[0].fixed_ip_v4
}

output "details" {
  description = "Details of the instances"
  value = {
    for instance in openstack_compute_instance_v2.instance :
    instance.name => instance.network[0].fixed_ip_v4
  }
}


