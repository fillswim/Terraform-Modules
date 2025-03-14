variable "project_name" {
  type = string
}

variable "user_name" {
  type = string
}

variable "user_password" {
  type = string
}

variable "image_source_url" {
  type    = string
  default = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
}

variable "image_name" {
  type    = string
  default = "Ubuntu 24.04 LTS"
}
