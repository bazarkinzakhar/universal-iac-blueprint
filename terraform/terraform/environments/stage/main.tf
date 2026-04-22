# поиск зон доступности
data "aws_availability_zones" "available" {
  state = "available"
}

module "networking" {
  source = "../../modules/vpc"

  env_name       = "stage"
  vpc_cidr       = "10.10.0.0/16"
  public_subnets = ["10.10.1.0/24", "10.10.2.0/24"]
  azs            = slice(data.aws_availability_zones.available.names, 0, 2)
}

module "compute" {
  source = "../../modules/compute"

  env_name          = "stage"
  vpc_id            = module.networking.vpc_id
  public_subnet_ids = module.networking.public_subnet_ids
  instance_count    = 1
  instance_type     = "t3.micro"
  ssh_public_key    = var.ssh_key # переменная из variables.tf
}