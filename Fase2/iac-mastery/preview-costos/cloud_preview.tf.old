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

# Simulamos una instancia EC2 pesada que genera costos altos
resource "aws_instance" "servidor_produccion" {
  ami           = "ami-0c55b159cbfafe1f0" # ID de ejemplo para Amazon Linux
  instance_type = "m5.4xlarge"            # Una máquina costosa
}
