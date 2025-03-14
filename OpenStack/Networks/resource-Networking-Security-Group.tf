
resource "openstack_networking_secgroup_v2" "secgroup_1" {
  name        = var.secgroup_name
  description = "My neutron security group"
}

# TCP
resource "openstack_networking_secgroup_rule_v2" "secgroup_rule_1" {
  direction      = "ingress"
  ethertype      = "IPv4"
  protocol       = "tcp"
  port_range_min = 0
  port_range_max = 0
  # port_range_min    = 22
  # port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.secgroup_1.id
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_rule_2" {
  direction      = "egress"
  ethertype      = "IPv4"
  protocol       = "tcp"
  port_range_min = 0
  port_range_max = 0
  # port_range_min    = 22
  # port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.secgroup_1.id
}

# UDP
resource "openstack_networking_secgroup_rule_v2" "secgroup_rule_3" {
  direction      = "ingress"
  ethertype      = "IPv4"
  protocol       = "udp"
  port_range_min = 0
  port_range_max = 0
  # port_range_min    = 22
  # port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.secgroup_1.id
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_rule_4" {
  direction      = "egress"
  ethertype      = "IPv4"
  protocol       = "udp"
  port_range_min = 0
  port_range_max = 0
  # port_range_min    = 22
  # port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.secgroup_1.id
}

# ICMP
resource "openstack_networking_secgroup_rule_v2" "secgroup_rule_5" {
  direction      = "ingress"
  ethertype      = "IPv4"
  protocol       = "icmp"
  port_range_min = 0
  port_range_max = 0
  # port_range_min    = 22
  # port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.secgroup_1.id
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_rule_6" {
  direction      = "egress"
  ethertype      = "IPv4"
  protocol       = "icmp"
  port_range_min = 0
  port_range_max = 0
  # port_range_min    = 22
  # port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.secgroup_1.id
}