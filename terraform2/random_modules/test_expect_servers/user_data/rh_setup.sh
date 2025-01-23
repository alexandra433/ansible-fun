#!/bin/bash -xe
# https://www.gnu.org/software/bash/manual/html_node/Invoking-Bash.html#Invoking-Bash
# https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html
# -e: exit immediately if a command returns a non-zero status
# -x: each command and its arguments to stderr before executing it

# 1. Create ansible_usr
sudo useradd -m ansible_usr
$PASSWD=hahayouthought
echo $PASSWD | passwd --stdin ansible_usr
# 2. Give ansible_usr ssh access

# 3. Make ansible_usr sudoer without password? (Maybe not)

# 4. Restart ssh

# 5. Download perl expect module, pexpect, ...?