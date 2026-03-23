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

ansible-playbook test_partition.yml --extra-vars "survey_target=deb_server1" -v

```
root@ip-172-31-16-201:~/ansible-fun# ansible-playbook test_partition.yml --extra-vars "survey_target=deb_server1, ansible_usr_pass=<redacted>" -v
Using /root/ansible-fun/ansible.cfg as config file

PLAY [Test a simple use case of the expect module] ********************************************************

TASK [Gathering Facts] ************************************************************************************
[WARNING]: Host '18.216.157.58' is using the discovered Python interpreter at '/usr/bin/python3.13', but future installation of another Python interpreter could cause a different interpreter to be discovered. See https://docs.ansible.com/ansible-core/2.20/reference_appendices/interpreter_discovery.html for more information.
ok: [18.216.157.58]

TASK [add_partition : Get partiton info] ******************************************************************
changed: [18.216.157.58] => {"changed": true, "cmd": "/usr/sbin/fdisk -l | grep /dev/xvda2", "delta": "0:00:00.006112", "end": "2026-03-23 21:01:50.851462", "failed_when_result": false, "failed_when_suppressed_exception": "(traceback unavailable)", "msg": "non-zero return code", "rc": 1, "start": "2026-03-23 21:01:50.845350", "stderr": "GPT PMBR size mismatch (16777215 != 20971519) will be corrected by write.\nThe backup GPT table is not on the end of the device.", "stderr_lines": ["GPT PMBR size mismatch (16777215 != 20971519) will be corrected by write.", "The backup GPT table is not on the end of the device."], "stdout": "", "stdout_lines": []}

TASK [add_partition : check putput] ***********************************************************************
ok: [18.216.157.58] => {
    "changed": false,
    "msg": "All assertions passed"
}

TASK [add_partition : Run fdisk command.] *****************************************************************
[ERROR]: Task failed: Action failed.
Origin: /root/ansible-fun/roles/add_partition/tasks/main.yml:35:3

33   become_user: root
34
35 - name: Run fdisk command.
     ^ column 3

fatal: [18.216.157.58]: FAILED! => {"changed": true, "cmd": "echo -e \"n\\n2\\n\\n\\nt\\n2\\n44\\nw\" | /usr/sbin/fdisk /dev/xvda", "delta": "0:00:00.051070", "end": "2026-03-23 21:01:51.343724", "failed_when_result": true, "msg": "", "rc": 0, "start": "2026-03-23 21:01:51.292654", "stderr": "GPT PMBR size mismatch (16777215 != 20971519) will be corrected by write.\nThe backup GPT table is not on the end of the device. This problem will be corrected by write.\nThis disk is currently in use - repartitioning is probably a bad idea.\nIt's recommended to umount all file systems, and swapoff all swap\npartitions on this disk.\n\n-: unknown command\n2: unknown command\n\n\nPartition 2 does not exist yet!\n4: unknown command", "stderr_lines": ["GPT PMBR size mismatch (16777215 != 20971519) will be corrected by write.", "The backup GPT table is not on the end of the device. This problem will be corrected by write.", "This disk is currently in use - repartitioning is probably a bad idea.", "It's recommended to umount all file systems, and swapoff all swap", "partitions on this disk.", "", "-: unknown command", "2: unknown command", "", "", "Partition 2 does not exist yet!", "4: unknown command"], "stdout": "\nWelcome to fdisk (util-linux 2.41).\nChanges will remain in memory only, until you decide to write them.\nBe careful before using the write command.\n\n\nCommand (m for help): \nCommand (m for help): \nCommand (m for help): \nCommand (m for help): \nCommand (m for help): Partition number (1,14,15, default 15): \nCommand (m for help): \nCommand (m for help): \nThe partition table has been altered.\nSyncing disks.", "stdout_lines": ["", "Welcome to fdisk (util-linux 2.41).", "Changes will remain in memory only, until you decide to write them.", "Be careful before using the write command.", "", "", "Command (m for help): ", "Command (m for help): ", "Command (m for help): ", "Command (m for help): ", "Command (m for help): Partition number (1,14,15, default 15): ", "Command (m for help): ", "Command (m for help): ", "The partition table has been altered.", "Syncing disks."]}

PLAY RECAP ************************************************************************************************
18.216.157.58              : ok=3    changed=1    unreachable=0    failed=1    skipped=0    rescued=0    ignored=0
```