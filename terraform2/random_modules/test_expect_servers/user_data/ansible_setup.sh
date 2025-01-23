#!/bin/bash -xe
# https://www.gnu.org/software/bash/manual/html_node/Invoking-Bash.html#Invoking-Bash
# https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html
# -e: exit immediately if a command returns a non-zero status
# -x: each command and its arguments to stderr before executing it

# Scripts entered as user data are run as the root user 9https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/user-data.html)
# 1. Download ansible
apt update
apt upgrade -y
apt -y install software-properties-common
apt-add-repository ppa:ansible/ansible
apt install ansible -y

# 2. Install passlib (for password_hash('sha512'))
apt install python3-passlib

# 3. Clone the repo (to root directory for now)
cd /root
git clone https://github.com/alexandra433/ansible-fun.git

# 4. Set up Ansible Vault
cd /root/ansible-fun
echo ${vault_pass} > .vault_pass