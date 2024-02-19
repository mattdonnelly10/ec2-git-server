resource "aws_key_pair" "localssh" {
  key_name   = var.git_server_key_name
  public_key = var.public_ssh_key
}