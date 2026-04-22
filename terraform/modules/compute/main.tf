data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

# 2. Firewall
resource "aws_security_group" "web" {
  name        = "${var.env_name}-web-sg"
  vpc_id      = var.vpc_id

  # SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # заменить на список разрешенных ip
  }

  # HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # исходящий трафик разрешен
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# SSH Ключ
resource "aws_key_pair" "deployer" {
  key_name   = "${var.env_name}-deployer-key"
  public_key = var.ssh_public_key
}

# инстансы
resource "aws_instance" "app_server" {
  count                  = var.instance_count
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = var.public_subnet_ids[count.index % length(var.public_subnet_ids)]
  vpc_security_group_ids = [aws_security_group.web.id]
  key_name               = aws_key_pair.deployer.key_name

  tags = {
    Name        = "${var.env_name}-server-${count.index + 1}"
    Project     = "Universal-IaC"
    Role        = "web" # важно для Ansible динамического инвентаря
    Environment = var.env_name
  }
}