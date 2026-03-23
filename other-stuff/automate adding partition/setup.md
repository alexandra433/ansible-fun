**Provision servers**
----------------------------
Launch a t2.micro Ubuntu instance for the ansible controller node
Create two more t2.micro instances (chose Debian for now). Update inventory.ini file with their public ips

- created a key pair and downloaded it here
 
/c/Users/alexa/Documents/learning/aws

alexa@mylaptop2 MINGW64 ~/Documents/learning/aws
$ pwd
/c/Users/alexa/Documents/learning/aws

alexa@mylaptop2 MINGW64 ~/Documents/learning/aws
$ ll
total 4
-rw-r--r-- 1 alexa 197609 1678 Mar  9 12:11 alex-account2.pem

alexa@mylaptop2 MINGW64 ~/Documents/learning/aws
$ chmod 400 "alex-account2.pem"

alexa@mylaptop2 MINGW64 ~/Documents/learning/aws
$ ssh -i "alex-account2.pem" ubuntu@ec2-18-116-114-197.us-east-2.compute.amazonaws.com



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

```
ansible_user_pass: !vault |
          $ANSIBLE_VAULT;1.1;AES256
          34313231663434373062623565613462636163363866333536336137626235383237643135363532
          6434343236653962396230626563386362333163373037300a346531313830313630626437346532
          39626465313931656235646131393030333661633434643663313838393163376366363531306463
          6565333534643166340a386361396234383863666331333238353064666331356634666536663732
          6532
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

