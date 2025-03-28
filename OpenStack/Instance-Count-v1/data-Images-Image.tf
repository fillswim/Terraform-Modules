
# Получить id образа с Ubuntu 24.04
data "openstack_images_image_v2" "image" {
  name        = var.image-name
  most_recent = true
}

output "image-id" {
  value = data.openstack_images_image_v2.image.id
}