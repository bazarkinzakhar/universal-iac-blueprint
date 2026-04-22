output "vpc_id" {
  description = "ID созданной VPC"
  value       = aws_vpc.this.id
}

output "public_subnet_ids" {
  description = "Список ID публичных подсетей"
  value       = aws_subnet.public[*].id
}