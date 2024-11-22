# Proveedor de AWS: Aquí definimos el proveedor y la región en la que desplegaremos nuestros recursos.
provider "aws" {
region = var.aws_region
}

# Crear una VPC
resource "aws_vpc" "VPC_13" {
cidr_block = "10.0.0.0/16"  # Cambia el CIDR según tus necesidades
}

# Crear una subred
resource "aws_subnet" "subnet_13" {
vpc_id            = aws_vpc.VPC_13.id
availability_zone = var.vpc_availability_zone      # Zona de disponibilidad
cidr_block        = "10.0.1.0/24"  # CIDR para la subred
}


# Grupo de seguridad
# Permite tráfico HTTP, HTTPS y SSH hacia la instancia EC2.
resource "aws_security_group" "SG_Desafio13" {
description = "Allow HTTP, HTTPS, and SSH traffic"
vpc_id = aws_vpc.VPC_13.id # Asegúrate de que el SG está asociado a la misma VPC que la subred



ingress {                                   # Regla de entrada para HTTP
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}

ingress {                                   # Regla de entrada para HTTPS
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}

ingress {                                   # Regla de entrada para SSH
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}

egress {                                    # Regla de salida para permitir tráfico saliente
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
}
}

# Recurso de Instancia EC2
resource "aws_instance" "My_Web13" {
ami           = var.ami_id
instance_type = var.instance_type

subnet_id             = aws_subnet.subnet_13.id  # Asocia la subred
vpc_security_group_ids = [aws_security_group.SG_Desafio13.id] # Asocia el Security Group creado a la instancia

tags = {                                    # Etiquetas que describen el recurso
    Owner          = "Martin"
    Email          = "Martin@educacionit.com"
    Team           = "DevOpsTeam"
    Proyectogrupo1 = "Desafio 13"
}

}

terraform {
  backend "remote" {
    organization = "Martin-DevOps_org"

    workspaces {
      name = "terraform-aws-poc"
    }
  }
}
