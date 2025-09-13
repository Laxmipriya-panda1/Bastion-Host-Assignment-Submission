terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.0"
}

provider "aws" {
  region = var.region
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = { Name = "bastion-assessment-vpc" }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidr
  map_public_ip_on_launch = true
  tags = { Name = "public-subnet" }
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_cidr
  tags = { Name = "private-subnet" }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = { Name = "public-rt" }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id = aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_security_group" "bastion_sg" {
  name        = "bastion-sg"
  description = "Allow SSH from admin IP"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.admin_cidr]
    description = "SSH from admin IP"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "private_sg" {
  name        = "private-sg"
  description = "Allow SSH from bastion only"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
    description = "SSH from bastion"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "bastion" {
  ami           = var.ami
  instance_type = var.bastion_instance_type
  subnet_id     = aws_subnet.public.id
  key_name      = var.key_name
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
  user_data = file("${path.module}/../scripts/bastion-userdata.sh")
  tags = { Name = "bastion-host" }
}

resource "aws_instance" "private" {
  ami           = var.ami
  instance_type = var.private_instance_type
  subnet_id     = aws_subnet.private.id
  key_name      = var.key_name
  associate_public_ip_address = false
  vpc_security_group_ids = [aws_security_group.private_sg.id]
  user_data = file("${path.module}/../scripts/private-userdata.sh")
  tags = { Name = "private-server" }
}

output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}

output "private_ip" {
  value = aws_instance.private.private_ip
}
