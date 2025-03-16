
# Получить id типа инстанса "m1.medium"
data "openstack_compute_flavor_v2" "m1_medium" {
  name = var.flavor-name
}