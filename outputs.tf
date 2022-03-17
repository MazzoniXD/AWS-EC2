output "public_ip" {
  value = aws_instance.server.public_ip
}

output "group_id" {
  value = "${aws_security_group.ssh.id}"
}