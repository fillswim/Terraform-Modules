
variable "instance-name-prefix" {
  description = "Префикс имени инстанса"
  type        = string
  default     = "instance"
  nullable    = true
}

variable "instance-count" {
  description = "Количество инстансов для создания"
  type        = number
  default     = 1
}

variable "starting-host-number" {
  description = "Начальный номер хоста (первый инстанс будет иметь IP-адрес, равный значению переменной)"
  type        = number
  default     = 11
}

variable "private-network-name" {
  description = "Имя приватной сети"
  type        = string
  default     = "private-subnet"
}

variable "private-subnet-name" {
  description = "Имя приватной подсети"
  type        = string
  default     = "private-subnet"
}

variable "public-network-name" {
  description = "Имя публичной сети"
  type        = string
  default     = "public"
  nullable    = true
}

# ================================================
# Другие параметры для создания инстансов
# ================================================

variable "admin-password" {
  description = "Пароль администратора"
  type        = string
}

variable "create-floating-ip" {
  description = "Создать ли публичный IP-адрес"
  type        = bool
  default     = false
}

variable "floating-ip-v4" {
  description = "IP-адрес для публичного интерфейса"
  type        = string
  default     = null
  nullable    = true
}

variable "flavor-name" {
  description = "Тип инстанса"
  type        = string
  default     = "m1.medium"
}

variable "keypair-name" {
  description = "Имя ключа"
  type        = string
  default     = "keypair-1"
}

variable "image-name" {
  description = "Имя образа"
  type        = string
  default     = "Ubuntu 24.04 LTS"
}

variable "secgroup-name" {
  description = "Имя группы безопасности"
  type        = string
  default     = "secgroup-1"
}
