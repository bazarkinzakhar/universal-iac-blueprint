variable "env_name"          { type = string }
variable "vpc_id"            { type = string }
variable "public_subnet_ids" { type = list(string) }
variable "instance_type"     { type = string; default = "t3.micro" }
variable "instance_count"    { type = number; default = 1 }
variable "ssh_public_key"    { type = string; description = "Публичный ключ для доступа" }