data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

# Firewall
resource "aws_security_group" "web_sg" {
  name        = "${var.env_name}-common-sg"
  description = "Allow SSH and HTTP"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # ограничить своим IP
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.env_name}-sg" }
}

# регистрация SSH ключа в AWS
resource "aws_key_pair" "auth" {
  key_name   = "${var.env_name}-deployer-key"
  public_key = var.ssh_public_key
}

# создание инстансов
resource "aws_instance" "node" {
  count                  = var.instance_count
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = var.public_subnet_ids[count.index % length(var.public_subnet_ids)]
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  key_name               = aws_key_pair.auth.key_name

  # теги для работы динамического инвентаря Ansible
  tags = {
    Name        = "${var.env_name}-node-${count.index + 1}"
    Environment = var.env_name
    Role        = "app"
    ManagedBy   = "Terraform"
  }
}