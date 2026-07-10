# Arquitectura de alta escala para producción masiva
resource "aws_instance" "cluster_node" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "c6i.4xlarge" # Cómputo pesado optimizado
}

resource "aws_ebs_volume" "disco_enterprise" {
  availability_zone = "us-east-1a"
  size              = 500 # 500 GB
  type              = "io2" # Disco de alta velocidad (Muy costoso)
  iops              = 3000
}
