variable "env_name" {
  description = "Имя окружения"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR блок для VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "Список CIDR блоков для публичных подсетей"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "azs" {
  description = "Список Availability Zones"
  type        = list(string)
}