resource "aws_security_group" "inbound_ssh" {
  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["${var.local_ip}/32"]
  }
}