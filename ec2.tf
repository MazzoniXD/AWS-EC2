data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  owners = ["099720109477"] # Canonical
}

provider "aws" {
  region  = var.region
  profile = "tf069"
}

resource "aws_security_group" "ssh"{
  name = "allow_ssh"
  description = "Allow SSH connectios"

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  vpc_security_group_ids = ["${aws_security_group.ssh.id}"]

  tags = {
    Name        = var.name
    Environment = var.env
    Provisioner = "Terraform"
    Repo        = var.repo
  }
}