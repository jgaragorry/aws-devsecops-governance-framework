# Arquitectura económica para pruebas
resource "aws_instance" "micro_server" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t3.micro"
}

resource "aws_ebs_volume" "disco_pequeno" {
  availability_zone = "us-east-1a"
  size              = 10 # 10 GB
  type              = "gp3"
}
