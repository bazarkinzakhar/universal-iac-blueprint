variable "env_name" {
  type        = string
  description = "Имя окружения"
}

variable "vpc_id" {
  type        = string
  description = "ID VPC для размещения ресурсов"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "Список подсетей для размещения"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "instance_count" {
  type    = number
  default = 1
}

variable "ssh_public_key" {
  type        = string
  description = "Публичный ключ для доступа по SSH"
}

variable "allowed_ips" {
  type        = list(string)
  description = "Список IPv4 CIDR блоков, которым разрешено подключение"
  default     = []
}