- bash script ver of ssh key generation
- fdisk boot issues
- Add extra volume to ec2, figure out how to partition and mount with fdisk
  - make script
- Do something about updating ips and dns names each time



Done:
- Create user, set password, set user expiration in one line
  - `useradd -p $(openssl passwd -1 password) user1 -e 2026-01-01`
- configure privilege escalation password for ansible
  - Added `ansible_become_pass:` variable to inventory
- ansible_ssh_pass= vs first time pinging hosts
  - Disable sshpass for host key checking when ping inventory first time with `ansible all -m ping --extra-vars "ansible_ssh_pass="`