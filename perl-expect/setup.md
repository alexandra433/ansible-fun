**Provision servers**
----------------------------
Launch a t2.micro Ubuntu instance for the ansible controller node
Create two more t2.micro instances (chose Debian). Update inventory.ini file with their public ips


**Ansible Server Setup**
----------------------------
SSH into ansible server

Setting up ansible (on ubuntu)
- https://www.cyberciti.biz/faq/how-to-install-and-configure-latest-version-of-ansible-on-ubuntu-linux/
```
# if already installed
sudo apt remove ansible
sudo apt --purge autoremove

sudo apt update
sudo apt upgrade
sudo apt -y install software-properties-common
sudo apt-add-repository ppa:ansible/ansible
sudo apt install ansible -y
```

- Install passlib on the ansible server for the create_ssh_user playbook (need it for this line "{{ survey_pass|password_hash('sha512') }}")
  - `sudo apt install python3-passlib`

Clone repo:
```
cd ~
git clone https://github.com/alexandra433/ansible-fun.git
```

**Remote servers setup**
-------------------------
Create ansible_usr on remote servers (server 1 and 2)
- need password-based ssh access to server
  - Creating user with password (on server1)
    - `sudo useradd -m ansible_usr`
    - `sudo passwd ansible_usr`
    - testing1274
  - Giving user ssh access https://linuxconfig.org/how-to-enable-and-disable-ssh-for-user-on-linux
    - `sudo nano /etc/ssh/sshd_config`
    - Add the following lines to the end of the file https://serverfault.com/questions/285800/how-to-disable-ssh-login-with-password-for-some-users:
    ```
    AllowUsers admin ansible_usr

    Match User ansible_usr
      PasswordAuthentication yes
    ```
  - Make ansible_usr a sudoer without password
    ```
    sudo visudo

    #Paste this line
    ansible_usr ALL=(ALL) NOPASSWD:ALL
    ```
  - Restart ssh
    - `sudo systemctl restart ssh`for debian
    - `sudo systemctl restart sshd` for redhat

**Run Playbooks**
-------------------------
- On ansible server, cd to git repo: `cd ansible-fun`
- Ping the hosts first
  - comment out `ansible_ssh_pass=testing1274` in inventory.ini temporarily for this to avoid `Using a SSH password instead of a key is not possible because Host Key checking is enabled and sshpass does not support this.  Please add this host's fingerprint to your known_hosts file to manage this host.`
  - `ansible all -m ping -i inventory.ini`
    - You'll see something like this. It is fine
    ```
    The authenticity of host '54.161.212.65 (54.161.212.65)' can't be established.
    ED25519 key fingerprint is SHA256:0htekVOjrKYQx1HcQgzYHSBpk1EPjFQNRXnEsn24jwI.
    This key is not known by any other names.
    Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
    54.161.212.65 | UNREACHABLE! => {
        "changed": false,
        "msg": "Failed to connect to the host via ssh: Warning: Permanently added '54.161.212.65' (ED25519) to the list of known hosts.\r\nansible_usr@54.161.212.65: Permission denied (publickey,password).",
        "unreachable": true
    }
    ```
  - Uncomment `ansible_ssh_pass=testing1274` in inventory.ini
  - Note: can consider adding `host_key_checking = false` to `[defaults]` in ansible.cfg
- Create myuser1 on both servers:
  - `ansible-playbook create_ssh_user.yml --extra-vars "survey_target=server1 username=myuser1 survey_pass=testing127 ansible_ssh_pass=testing1274" -v`
  - `ansible-playbook create_ssh_user.yml --extra-vars "survey_target=server2 username=myuser1 survey_pass=testing127 ansible_ssh_pass=testing1274" -v`
- Created testuser on server1
  - Without password in ini file: `ansible-playbook create_ssh_user.yml --extra-vars "survey_target=server1 survey_pass=testing127" --ask-pass -v`
  - With password: `ansible-playbook create_ssh_user.yml --extra-vars "survey_target=server1 survey_pass=testing127 ansible_ssh_pass=testing1274" -v`
- Run the generate_ssh_key script on server2
  - `ansible-playbook keygen_and_scp.yml --extra-vars "survey_target=server2 scp_host=ec2-18-234-186-130.compute-1.amazonaws.com scp_user=testuser user_pass=testing127 ansible_ssh_pass=testing1274" -v`
    - scp_host should be dns of server1

- To run the simple expect test:
  - `ansible-playbook test_simple_expect.yml --extra-vars "survey_target=server2 ansible_ssh_pass=testing1274" -v`
  - `ansible-playbook test_simple_expect.yml --extra-vars "survey_target=server2 expect_ver=ansible ansible_ssh_pass=testing1274" -v`