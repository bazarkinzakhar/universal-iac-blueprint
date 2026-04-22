# создание сети
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${var.env_name}-vpc"
    Environment = var.env_name
    ManagedBy   = "Terraform"
  }
}

# internet gateway для выхода в сеть
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.env_name}-igw"
  }
}

# создание публичных подсетей
resource "aws_subnet" "public" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true # Автоматически выдавать белый IP

  tags = {
    Name = "${var.env_name}-public-subnet-${count.index + 1}"
  }
}

# таблица маршрутизации, внешний трафик направляется в internet gateway
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "${var.env_name}-public-rt"
  }
}

# ассоциирование таблицы маршрутизации с подсетями
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}