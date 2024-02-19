output "git_server" {
  value = aws_instance.web.public_dns
}

output "instance_id" {
    value = aws_instance.web.id
}
