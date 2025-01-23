#!/bin/bash -xe
# https://www.gnu.org/software/bash/manual/html_node/Invoking-Bash.html#Invoking-Bash
# https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html
# -e: exit immediately if a command returns a non-zero status
# -x: each command and its arguments to stderr before executing it

# 1. Download ansible
sudo apt update
sudo apt upgrade -y
sudo apt -y install software-properties-common
sudo apt-add-repository ppa:ansible/ansible
sudo apt install ansible -y

# 2. Install passlib
sudo apt install python3-passlib

# 3. Clone the repo (to root directory for now)
cd /root
git clone https://github.com/alexandra433/ansible-fun.git

# 4. Set up Ansible Vault?