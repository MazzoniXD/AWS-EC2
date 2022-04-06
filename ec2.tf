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
}

resource "aws_s3_bucket" "terraform-state" {
  bucket = "thiagomazzoni-state"
}

resource "aws_s3_bucket_acl" "example" {
  bucket = aws_s3_bucket.terraform-state.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.terraform-state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_security_group" "ssh" {
  name        = "allow_ssh"
  description = "Allow SSH connectios"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = "id_rsa"
  vpc_security_group_ids = ["${aws_security_group.ssh.id}"]
  lifecycle {
    ignore_changes = [
      ami
    ]
  }

  tags = {
    Name        = var.name
    Environment = var.env
    Provisioner = "Terraform"
    Repo        = var.repo
  }
}

resource "aws_key_pair" "deployer" {
  key_name = "id_rsa"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDLvrhpB22gIn5oXEl0zg+tbfkIGI5NqlV9Z3GGueLTWt/xM3Nh2GxYLStA99qLHfzsxUYYI11lqaF8lAmjYegYFjjyFRo3N27RoT0jPyOaQ5QQmypkTv8jMUHe5GuVBgudfTM0OL3g7Br4W+W9ERm34c7o+lIDpWrXfkd6jOSWPp63Hc8D0ws2RTpxB/qOXGM6MENLJBTOO2oY4ZCHhNUWNZL0a9fsTySqPsgIPsYbppjra6raXMXcj+OcaROhnD3/Ru+hpbRTxwiYgDZ3tXR93Z0b6CPRpi9iczG6cAIdIWP3glC5oPKaIyP8o4NNTB08hQH53hczsJNS+okGmRfj mazzoni@DESKTOP-PNJ0R8Q"
}