#!/bin/bash -xe
# https://www.gnu.org/software/bash/manual/html_node/Invoking-Bash.html#Invoking-Bash
# https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html
# -e: exit immediately if a command returns a non-zero status
# -x: each command and its arguments to stderr before executing it

# Scripts entered as user data are run as the root user 9https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/user-data.html)
# 1. Create ansible_usr (with home directory)
sudo useradd -p $(openssl passwd -1 ${ansible_usr_pass}) -m ansible_usr
# 2. Give ansible_usr ssh access
echo "" >> /etc/ssh/sshd_config
echo "AllowUsers admin ansible_usr" >> /etc/ssh/sshd_config
echo "" >> /etc/ssh/sshd_config
echo "Match User ansible_usr" >> /etc/ssh/sshd_config
echo "  PasswordAuthentication yes" >> /etc/ssh/sshd_config
# 3. Make ansible_usr sudoer without password? (Maybe not)
# 3. Make ansible_usr a sudoer
adduser ansible_usr sudo
# 4. Restart ssh
systemctl restart ssh
# 5. Download perl expect module, pexpect, ...?