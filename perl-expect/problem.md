Want to use perl expect module to automate ssh keygen and scp to a server

ssh keygen:
--------------------------


connecting
```
The authenticity of host 'ec2-3-86-90-147.compute-1.amazonaws.com (3.86.90.147)' can't be established.
ED25519 key fingerprint is SHA256:9hcpt4x4IRVDB0tFcY4by2GG0vfX0CaloLbpmWNFtbw.
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])?
```


Perl resources
-----------------------
https://www.perlmonks.org/?node_id=786670
https://metacpan.org/pod/Expect
https://gist.github.com/tommybutler/6934497

***Steps taken:***
----------------------------
***Simple testing***
- Launched a t2.micro instance with the free tier debian 12 ami
- sshed in with `ssh -i "A4L.pem" admin@ec2-3-86-90-147.compute-1.amazonaws.com`
  - A4L.pem is in ~/Downloads/aws saa/ssh key pair
- Tried to `ll`, command not found
  - added `alias ll=ls -la` line in `/root/.bashrc`, then loaded the .bashrc file with `source /root/.bashrc`
  - did the same with `/home/admin/.bashrc`
- Downloading the expect module
  -https://unix.stackexchange.com/questions/506938/how-to-install-perl-modules-on-debian-9
  - became root `sudo su root`
  ```
  apt update
  apt install apt-file
  apt-file update
  apt-file search Expect.pm
  ```
  - The search command gave these results:
  ```
  root@ip-172-31-93-99:/home/admin# apt-file search Expect.pm
  libexpect-perl: /usr/share/perl5/Expect.pm
  libnet-scp-expect-perl: /usr/share/perl5/Net/SCP/Expect.pm
  libtest-expect-perl: /usr/share/perl5/Test/Expect.pm
  rex: /usr/share/perl5/Rex/Helper/SSH2/Expect.pm
  ```
  - Ran `apt install libexpect-perl`
- Tested the simple-expect.pl script first
  - created read-input.sh in /home/admin
  - chmod 777 read-input.sh
  - created in /home/admin/testing folder used in the read-input.sh script
  - created simple-expect.pl /home/admin
  - With args: `root@ip-172-31-93-99:/home/admin# ./simple-expect.pl apple testing3.txt`
  - Without: `root@ip-172-31-93-99:/home/admin# ./simple-expect.pl`

***Trying to generate keys (manual)***
- launched another ec2 instance to ssh into
Manually creating the key
- https://www.digitalocean.com/community/tutorials/how-to-configure-ssh-key-based-authentication-on-a-linux-server
  ```
  admin@ip-172-31-88-189:~$ ssh-keygen
  Generating public/private rsa key pair.
  Enter file in which to save the key (/home/admin/.ssh/id_rsa):
  Enter passphrase (empty for no passphrase):
  Enter same passphrase again:
  Your identification has been saved in /home/admin/.ssh/id_rsa
  Your public key has been saved in /home/admin/.ssh/id_rsa.pub
  The key fingerprint is:
  SHA256:+x42zO+xq5/q6m56qMb5MS4HjIuih2uNe1KEeD+pFes admin@ip-172-31-88-189
  The key's randomart image is:
  +---[RSA 3072]----+
  |                 |
  |                 |
  |. .              |
  |.....            |
  | ..+ +  S        |
  |  ..O    +       |
  | o+* +o.. * .    |
  |+++oE.oooo + +   |
  |*++..=+*++*=B.   |
  +----[SHA256]-----+
  ```
    - This key no longer exists btw
Manually copying the public key to another server
- need password-based ssh access to server
  - Creating user with password (on server1)
    - `sudo useradd -m testuser`
    - `passwd testuser`
    - testing127
  - Giving user ssh access https://linuxconfig.org/how-to-enable-and-disable-ssh-for-user-on-linux
    - `sudo nano /etc/ssh/sshd_config`
    - Add `AllowUsers testuser` to end of file
    - Add the following lines https://serverfault.com/questions/285800/how-to-disable-ssh-login-with-password-for-some-users:
    ```
    Match User testuser
      PasswordAuthentication yes
    ```
  - Optionally make testuser a sudoer
    - `sudo usermod -aG sudo testuser`
  - Restart ssh
    - `sudo systemctl restart ssh`for debian
    - `sudo systemctl restart sshd` for redhat
- Now on server2, copy the public key over to server 1 with
  - `ssh-copy-id username@remote_host`
    - `ssh-copy-id testuser@testuser@ec2-3-86-90-147.compute-1.amazonaws.com`
  ```
  admin@ip-172-31-88-189:~$ ssh-copy-id testuser@ec2-3-86-90-147.compute-1.amazonaws.com
  /usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/home/admin/.ssh/id_rsa.pub"
  The authenticity of host 'ec2-3-86-90-147.compute-1.amazonaws.com (172.31.93.99)' can't be established.
  ED25519 key fingerprint is SHA256:9hcpt4x4IRVDB0tFcY4by2GG0vfX0CaloLbpmWNFtbw.
  This key is not known by any other names.
  Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
  /usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
  /usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
  testuser@ec2-3-86-90-147.compute-1.amazonaws.com's password:

  Number of key(s) added: 1

  Now try logging into the machine, with:   "ssh 'testuser@ec2-3-86-90-147.compute-1.amazonaws.com'"
  and check to make sure that only the key(s) you wanted were added.

  ```

***Using perl script (no ansible)***
- Create two t2.micro debian instances
- Downloaded expect module on server 1 and copied the keygen.pl script there in `/home/admin`
  - `chmod 777 keygen.pl`
- Created testuser on server 2
- Ran the keygen.pl script
  - `perl home/admin/keygen.pl <server2_hostname> testuser testing127`
  - Ex: `perl home/admin/keygen.pl ec2-3-87-173-175.compute-1.amazonaws.com testuser testing127`

***Ansible***
----------------------------------------
Setting up ansible tower
- Decided to just run ansible locally
  - perhaps... https://github.com/kurokobo/awx-on-k3s

Setting up ansible (on ubuntu)
- https://www.cyberciti.biz/faq/how-to-install-and-configure-latest-version-of-ansible-on-ubuntu-linux/
```
sudo apt remove ansible
sudo apt --purge autoremove
sudo apt update
sudo apt upgrade
sudo apt -y install software-properties-common
sudo apt-add-repository ppa:ansible/ansible
sudo apt install ansible -y
```
Set up ansible.cfg
```
[defaults]
inventory = ./inventory.ini
remote_user = ansible_usr
```
Create inventory.ini
```
[server1]
<server1-ip>
[server2]
<server2-ip>

#optionally, otherwise use --ask-pass when running ansible-playbook cmd
[all:vars]
ansible_ssh_pass=testing1274
```

Create ansible_usr on remote servers (server 1 and 2)
- need password-based ssh access to server
  - Creating user with password (on server1)
    - `sudo useradd -m ansible_usr`
    - `sudo passwd ansible_usr`
    - testing1274
  - Giving user ssh access https://linuxconfig.org/how-to-enable-and-disable-ssh-for-user-on-linux
    - `sudo nano /etc/ssh/sshd_config`
    - Add `AllowUsers admin ansible_usr` to end of file
    - Add the following lines https://serverfault.com/questions/285800/how-to-disable-ssh-login-with-password-for-some-users:
    ```
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

Recreated the roles and yml files on the ansible server under a folder called "ansible"
- Install passlib on the ansible server for the create_ssh_user playbook
  - `sudo apt install python3-passlib`
- Ping the hosts first `ansible server1 -m ping -i inventory.ini`, ` ansible server2 -m ping -i inventory.ini`
- Create myuser1 on both servers:
  - `ansible-playbook create_ssh_user.yml --extra-vars "survey_target=server1 username=myuser1 survey_pass=testing127" -v`
- Created testuser on server1
  - Without password in ini file: `ansible-playbook create_ssh_user.yml --extra-vars "survey_target=server1 survey_pass=testing127" --ask-pass -v`
  - With password: `ansible-playbook create_ssh_user.yml --extra-vars "survey_target=server1 survey_pass=testing127" -v`
- Run the generate_ssh_key script on server2
  - `ansible-playbook keygen_and_scp.yml --extra-vars "survey_target=server2 scp_host=ec2-44-202-62-220.compute-1.amazonaws.com scp_user=testuser user_pass=testing127" -v`

Other tidbits:
----------------------------
Run `ansible myhost -m setup` to see facts gathered