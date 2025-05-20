
resource "proxmox_virtual_environment_download_file" "download_file" {
  count        = var.count_proxmox_nodes
  node_name    = "proxmox${1 + count.index}"
  content_type = var.image_type
  datastore_id = var.image_datastore
  url          = var.image_url
  file_name    = var.image_name
}

output "details" {
  value = join("\n\n", [
    for file in proxmox_virtual_environment_download_file.download_file : join("\n", [
      format("Node:         %s", file.node_name),
      format("  File:       %s", file.file_name),
      format("  URL:        %s", file.url),
      format("  Storage:    %s", file.datastore_id),
      format("  Image Type: %s", file.content_type),
    ])
  ])
}