data "aws_availability_zones" "available" {
  state = "available"
}

module "networking" {
  source = "../../modules/vpc"

  env_name       = var.env
  vpc_cidr       = "10.10.0.0/16"
  public_subnets = ["10.10.1.0/24", "10.10.2.0/24"]
  
  azs            = slice(data.aws_availability_zones.available.names, 0, 2) 
}