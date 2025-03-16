
# resource "openstack_images_image_v2" "ubuntu" {
#   name             = var.image_name
#   image_source_url = var.image_source_url
#   container_format = "bare"
#   disk_format      = "qcow2"
#   visibility       = "shared"
# }