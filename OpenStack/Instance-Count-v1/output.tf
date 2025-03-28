
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