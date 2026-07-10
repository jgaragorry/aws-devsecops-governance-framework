terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# Servidor de cómputo intensivo
resource "aws_instance" "nodo_computo" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "c6i.4xlarge"
}

# Disco de alta velocidad (io2 es el más caro)
resource "aws_ebs_volume" "almacenamiento_rapido" {
  availability_zone = "us-east-1a"
  size              = 500
  type              = "io2"
  iops              = 3000
}
