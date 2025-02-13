**Provision servers**
----------------------------
Launch a t2.micro Ubuntu instance for the ansible controller node
Create two more t2.micro instances (chose Debian for now). Update inventory.ini file with their public ips


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

Setup Ansible vault:
- Create a vault password file to store the vault password used to encrypt other files
  - On the ansible server, create a file with the vault password (do not add to version control) inside the ansible directory
    - `echo '<vault password>' > .vault_pass`
  - Edit the `ansible.cfg` file to include the location of the password file so that you don't have to provide it when running ansible commands or when encrypting with `ansible-vault `
  ```
    [defaults]
    . . .
    vault_password_file = ./.vault_pass
  ```
- https://www.reddit.com/r/ansible/comments/q0wzgh/proper_password_management_in_playbookshosts_files/
- Generate encrypted passwords using command: `ansible-vault encrypt_string '<password>' --name "<nametoidentifypassword>"`. Save the output (`!vault | $ANSIBLE_VAULT; ...`) for later
  - `ansible-vault encrypt_string '<password>' --name "ansible_usr_pass"`
  - `ansible-vault encrypt_string '<password>' --name "ssh_user_pass"`
  - If you set up ansible.cfg with vault_password_file, you shouldn't be prompted for a password
- Inside the group_vars directory, create a file `all.yml` Past the outputs of the previous commands into it
  ```
  ---
  ansible_usr_pass: !vault | $ANSIBLE_VAULT; ...
  survey_pass: !vault | $ANSIBLE_VAULT; ...
  ```
  - `ansible_ssh_pass: "{{ ansible_usr_pass }}"` was added to `hosts.yml`
  - Added the following to relevant playbooks
  ```
  vars:
    survey_pass: "{{ ssh_user_pass }}"
  ```


**Remote servers setup**
-------------------------
Create ansible_usr on remote servers (server 1 and 2)
- need password-based ssh access to server
  - Creating user with password
    - `sudo useradd -m ansible_usr`
    - `sudo passwd ansible_usr`
    - enter password
  - Giving user ssh access https://linuxconfig.org/how-to-enable-and-disable-ssh-for-user-on-linux
    - `sudo nano /etc/ssh/sshd_config`
    - Add the following lines to the end of the file https://serverfault.com/questions/285800/how-to-disable-ssh-login-with-password-for-some-users:
    ```
    AllowUsers admin ansible_usr

    Match User ansible_usr
      PasswordAuthentication yes
    ```
      - `ec2-user` instead of `admin` for aws redhat
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
  - `ansible all -m ping --extra-vars "ansible_ssh_pass="`
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
- Create myuser1 on both servers:
  - `ansible-playbook create_ssh_user.yml --extra-vars "survey_target=deb_server1 username=myuser1" -v`
  - `ansible-playbook create_ssh_user.yml --extra-vars "survey_target=deb_server2 username=myuser1" -v`
- Created testuser on server1
  - `ansible-playbook create_ssh_user.yml --extra-vars "survey_target=deb_server1" -v`
- Run the generate_ssh_key script on server2
  - `ansible-playbook keygen_and_scp.yml --extra-vars "survey_target=deb_server2 scp_host=ec2-54-87-38-24.compute-1.amazonaws.com scp_user=testuser" -v`
    - scp_host should be dns of server1
  - `ansible-playbook keygen_and_scp.yml --extra-vars "survey_target=rh_server2 scp_host=ec2-52-201-236-29.compute-1.amazonaws.com scp_user=testuser expect_ver=ansible" -v`

- To run the simple expect test:
  - `ansible-playbook test_simple_expect.yml --extra-vars "survey_target=deb_server2" -v`
  - `ansible-playbook test_simple_expect.yml --extra-vars "survey_target=deb_server2 expect_ver=ansible" -v`

- password change:
  - `ansible-playbook change_ansible_pw.yml --extra-vars "survey_target=deb_server1 new_pass=" -v`

Other tidbits:
----------------------------
Run `ansible <host> -m setup` to see facts gathered
