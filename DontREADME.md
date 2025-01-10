**Terraform**
-----------------------------


**Ansible Roles:**
-------------------------
Needs updating
**create_ssh_user**
- Creates a user with password-based ssh access to the server
- Variables:
  - Required:
    - survey_target: The server to run the ansible job on. (Hoping to set up AWX someday)
    - survey_pass: The password of the new user
    - ansible_ssh_pass: The password ansible needs to ssh into the server
  - Optional
    - username: Username of user to create. Defaults to testuser

**gen_ssh_key_ansible**
- Generates an ssh key and copies it to another server using the Ansible builtin expect module
- Variables:
    - Required:
    - survey_target: The server to run the ansible job on. (Hoping to set up AWX someday)
    - scp_host: The DNS name of the server you want to copy the ssh key to
    - scp_user: The user that you are using to connect to the server you want to copy the ssh key to
    - user_pass: The password of scp_user
    - ansible_ssh_pass: The password ansible needs to ssh into the server

**gen_ssh_key_perl**
- Generates an ssh key and copies it to another server using perl scripts
- Variables:
  - Required:
    - survey_target: The server to run the ansible job on. (Hoping to set up AWX someday)
    - scp_host: The DNS name of the server you want to copy the ssh key to
    - scp_user: The user that you are using to connect to the server you want to copy the ssh key to
    - user_pass: The password of scp_user
    - ansible_ssh_pass: The password ansible needs to ssh into the server

**test_scp**
- Creates a txt file and scp's it to another server
- Variables:
  - Required:
    - survey_target: The server to run the ansible job on. (Hoping to set up AWX someday)
    - scp_host: The DNS name of the server you want to copy the ssh key to
    - scp_user: The user that you are using to connect to the server you want to copy the ssh key to
    - ansible_ssh_pass: The password ansible needs to ssh into the server

**test_simple_expect**
- Tests out a simple expect script that sends responses to a bash script expecting user input
- Variables:
  - Required:
    - survey_target: The server to run the ansible job on. (Hoping to set up AWX someday)
    - ansible_ssh_pass: The password ansible needs to ssh into the server
  - Optional:
    - expect_ver:
      - "perl" (default): Uses a perl script to send responses
      - "ansible": Uses the ansible expect module to send responses

**var_precendence**
- Tests variable precendence