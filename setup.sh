#!/bin/bash
echo "                                                                           
 _____ ____ ____     ____ ___ _____   ____  _____ ______     _______ ____  
| ____/ ___|___ \   / ___|_ _|_   _| / ___|| ____|  _ \ \   / | ____|  _ \ 
|  _|| |     __) | | |  _ | |  | |   \___ \|  _| | |_) \ \ / /|  _| | |_) |
| |__| |___ / __/  | |_| || |  | |    ___) | |___|  _ < \ V / | |___|  _ < 
|_____\____|_____|  \____|___| |_|   |____/|_____|_| \_\ \_/  |_____|_| \_\
                                                                           "
local_ip=`curl -s http://checkip.amazonaws.com`
echo "####################"
read -p "Enter the full (not relative) path to your public ssh key. " pub_ssh
public_ssh_key_contents=$(cat $pub_ssh)
echo "####################"
read -p "Enter the full (not relative) path to your private ssh key. " privatessh
echo "####################"
read -p "Enter the name for your new git repository or leave blank to create an empty git server with no repository. Do not use spaces or slashes. " project_name
echo "####################"
read -s -p "Enter the new password for the git user on the server. " gitpassword 
echo "####################"
read -p "Enter your desired aws region. Leave blank to use default us-east-1 " aws_region

if [ -z "$aws_region" ]; then
  aws_region="us-east-1"
fi
 
cd terraform
terraform init
terraform validate
terraform apply -var="aws_region=$aws_region" -var="local_ip=$local_ip" -var="public_ssh_key=$public_ssh_key_contents" --auto-approve
ipaddress=`terraform output git_server | sed 's/"//g'`
instanceid=`terraform output instance_id | sed 's/"//g'`
cd ../ansible
sed -i "/^\[git\]/{n;s/.*/${ipaddress}/}" ansible_hosts

# Check instance exists
aws ec2 wait instance-exists \
  --instance-ids $instanceid

# Check instance is healthy
echo "####################"
echo  "Waiting on instance health check, do not close your terminal. This may take a few minutes..."
aws ec2 wait instance-status-ok \
    --instance-ids $instanceid

ansible-playbook user_setup_with_params.yaml --extra-vars="hostname=git username=git upassword=$gitpassword"

ansible-playbook install_ssh_keys.yaml --extra-vars="hostname=git username=git"

if [ project_name ]; then
  ansible-playbook initialize_git.yaml --extra-vars="hostname=git git_base_dir=/home/git/ project=${project_name}"
  cd ..
  git clone ssh://git@"${ipaddress}"/home/git/$project_name
fi
