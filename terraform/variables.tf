variable "local_ip" {
    description = "IP address allowed to connect to ec2 instance."

    default = "0.0.0.0"
  
}

variable "public_ssh_key" {
    description = "Public ssh key."
    default = "~/.ssh/id_rsa.pub"
}

variable "git_server_key_name" {
    description = "Name for the git server key pair."
    default = "local-key"
  
}

variable "aws_region" {
    description = "Region for AWS provider"
    default = "us-east-1"
}