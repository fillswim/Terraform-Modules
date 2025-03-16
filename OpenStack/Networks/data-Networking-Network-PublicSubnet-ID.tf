
data "openstack_networking_subnet_v2" "public_subnet" {
  name = var.public_subnet_name
}
