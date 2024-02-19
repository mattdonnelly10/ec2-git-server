## A combination of Terraform and Ansible to setup a git server on an AWS EC2 instance.

### Requirements
* SSH public/private key pair

    You need a public and private key pair file to connect to the git server. If you do not have one, you can create it with this command: 

         ssh-keygen -t rsa -b 4096 -C "your_email@example.com"

* An AWS account

    You need an AWS account to run an ec2 instance. You can create an account here:
    https://aws.amazon.com/resources/create-account/

### Instructions
Clone this repository

    git clone https://github.com/mattdonnelly10/ec2-git-server.git && cd ec2-git-server


Install requirements (you can skip this if you have Terraform (greater than v1.0.0), AWS CLI, and Ansible installed)

* [Install Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
* [Install Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
* [Install AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)


Give yourself permission to run setup.sh

    chmod +x setup.sh

Run setup script

    ./setup.sh
*If you have a password on your private key, you will have to enter it a couple times during the script*

### Done
You are all set. Your git server is now running on ec2, you can access it with SSH:

    ssh -i path/to/private/key ubuntu@your-server-ip-or-domain-here

Your repository has been created in your current directory with remote origin set to your new git server.

### Other
* **Cost**

    This script deploys a t3.nano instance, which at time of writing, costs about $4 a month running 24/7. This is subject to change, do your own research to determine if the resources provisioned in this script meet your needs.
    
    The storage space is only 8gbs, someday I will add an S3 Git-LFS integration so bigger repositories can use this.

* **Adding users to the server**

    *For security, this instance is created with a security rule that only allows your IP address to connect to it. For other users to join, you need to add more ip addresses to the security group.*
    
    You can update the security group in terraform/security_group.tf file. Make sure to add using a CIDR range.
    
    Example: 123.456.789/32 to allow only that specific IP address.

    Once IP access is unblocked, you can create a new user on the server and add them to the git group.

    However, this isn't great because new users can access any repository. A better approach would be implementing [Gitolite](https://gitolite.com/gitolite/quick_install.html), an authorization tool for self-hosted git servers with fine-grained access control.

    Maybe someday I will add Gitolite to the default set up.

* **Remote terraform state**

    Terraform state should be stored remotely, but this script won't force you to. If you'd like to implement remote terraform state, you can follow the instructions on this link and add the remote state details to the terraform/providers.tf file: 

    https://developer.hashicorp.com/terraform/tutorials/aws-get-started/aws-remote
