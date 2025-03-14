
# Создать ключевую пару
resource "openstack_compute_keypair_v2" "keypair_1" {
  name       = var.ssh_keypair_1_name
  public_key = var.ssh_public_key_1
}