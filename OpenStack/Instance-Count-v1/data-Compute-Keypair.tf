
data "openstack_compute_keypair_v2" "keypair_1" {
  name = var.keypair-name
}

output "keypair_1_id" {
  value = data.openstack_compute_keypair_v2.keypair_1.id
}

