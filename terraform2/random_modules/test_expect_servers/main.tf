resource "aws_instance" "ansible_server" {
  ami                    = var.ubuntu_ami_us_east_1
  instance_type          = "t2.micro"
  key_name               = "A4L"
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "ansible_server_tf"
  }
  # user_data = file("./random_modules/test_expect_servers/user_data/ansible_setup.sh")
  user_data = base64encode(templatefile("./random_modules/test_expect_servers/user_data/ansible_setup.sh", {
    vault_pass = var.vault_pass
  }))
}

resource "aws_instance" "deb_server1" {
  ami                    = var.debian_ami_us_east_1
  instance_type          = "t2.micro"
  key_name               = "A4L"
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "deb_server1_tf"
  }
  user_data = base64encode(templatefile("./random_modules/test_expect_servers/user_data/host_setup.sh", {
    ansible_usr_pass = var.ansible_usr_pass
    default_aws_usr = var.host_config_map["debian"].default_aws_usr
    sudo_group = var.host_config_map["debian"].sudo_group
    ssh_service = var.host_config_map["debian"].ssh_service
  }))
}

resource "aws_instance" "deb_server2" {
  ami                    = var.debian_ami_us_east_1
  instance_type          = "t2.micro"
  key_name               = "A4L"
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "deb_server2_tf"
  }

  user_data = base64encode(templatefile("./random_modules/test_expect_servers/user_data/host_setup.sh", {
    ansible_usr_pass = var.ansible_usr_pass
    default_aws_usr = var.host_config_map["debian"].default_aws_usr
    sudo_group = var.host_config_map["debian"].sudo_group
    ssh_service = var.host_config_map["debian"].ssh_service
  }))
}

resource "aws_instance" "rh_server1" {
  ami                    = var.redhat_ami_us_east_1
  instance_type          = "t2.micro"
  key_name               = "A4L"
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "rh_server1_tf"
  }

  user_data = base64encode(templatefile("./random_modules/test_expect_servers/user_data/host_setup.sh", {
    ansible_usr_pass = var.ansible_usr_pass
    default_aws_usr = var.host_config_map["redhat"].default_aws_usr
    sudo_group = var.host_config_map["redhat"].sudo_group
    ssh_service = var.host_config_map["redhat"].ssh_service
  }))
}

resource "aws_instance" "rh_server2" {
  ami                    = var.redhat_ami_us_east_1
  instance_type          = "t2.micro"
  key_name               = "A4L"
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "rh_server2_tf"
  }

  user_data = base64encode(templatefile("./random_modules/test_expect_servers/user_data/host_setup.sh", {
    ansible_usr_pass = var.ansible_usr_pass
    default_aws_usr = var.host_config_map["redhat"].default_aws_usr
    sudo_group = var.host_config_map["redhat"].sudo_group
    ssh_service = var.host_config_map["redhat"].ssh_service
  }))
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow ssh inbound traffic and all outbound traffic"
  # vpc_id      = aws_vpc.main.id

  tags = {
    Name = "allow_ssh"
  }

  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
  }

  // Allow all outbound
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
