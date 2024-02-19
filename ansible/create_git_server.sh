#ansible-playbook install_git.yaml --extra-vars="hostname=git"

ansible-playbook user_setup_with_params.yaml --extra-vars="hostname=git username=git upassword=$gitpassword"

ansible-playbook initialize_git.yaml --extra-vars="hostname=git git_base_dir=/home/git/ project=newgitproject"

ansible-playbook install_ssh_keys.yaml --extra-vars="hostname=git username=git"


##git clone ssh://git@git/home/git/newgitproject
##ec2-35-173-223-162.compute-1.amazonaws.com



