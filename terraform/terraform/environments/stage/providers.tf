terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    # впишите имя бакета, которое выдаст output из bootstrap/main.tf
    bucket         = "ЗАМЕНИТЬ_НА_BUCKET_NAME_ИЗ_BOOTSTRAP"
    key            = "stage/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-state-locking"
    encrypt        = true
  }
}

provider "aws" {
  region = "eu-central-1"
}