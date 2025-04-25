# 3.0.1-rc8

# v1
* Added fixed_vmid variable (if not 0, then uses it instead of calculated from env)
* Added fixed_name variable (overrides vm_name + count.index + 1 )

# v2
* Added node_splitting variable (if true, then uses proxmox${1 + count.index} instead of proxmox_node)
