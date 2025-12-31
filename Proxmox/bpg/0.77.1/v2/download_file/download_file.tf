
resource "proxmox_virtual_environment_download_file" "download_file" {
  node_name    = var.proxmox_node_name
  content_type = var.image_type
  datastore_id = var.image_datastore
  url          = var.image_url
  file_name    = var.image_name
}

output "details" {
  value = join("\n", [
    format("==========================================================================="),
    format("                              Download File                                "),
    format("==========================================================================="),
    format("Node:         %s", proxmox_virtual_environment_download_file.download_file.node_name),
    format("  File:       %s", proxmox_virtual_environment_download_file.download_file.file_name),
    format("  URL:        %s", proxmox_virtual_environment_download_file.download_file.url),
    format("  Storage:    %s", proxmox_virtual_environment_download_file.download_file.datastore_id),
    format("  Image Type: %s", proxmox_virtual_environment_download_file.download_file.content_type),
    format("==========================================================================="),
  ])
}