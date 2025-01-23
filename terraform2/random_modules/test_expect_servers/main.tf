resource "aws_instance" "ansible_server" {
  ami                    = var.ubuntu_ami_us_east_1
  instance_type          = "t2.micro"
  key_name               = "A4L"
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "ansible_server_tf"
  }
  user_data = file("./random_modules/test_expect_servers/user_data/ansible_setup.sh")
}

resource "aws_instance" "deb_server1" {
  ami                    = var.debian_ami_us_east_1
  instance_type          = "t2.micro"
  key_name               = "A4L"
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "deb_server1_tf"
  }
}

resource "aws_instance" "deb_server2" {
  ami                    = var.debian_ami_us_east_1
  instance_type          = "t2.micro"
  key_name               = "A4L"
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "deb_server2_tf"
  }
}

resource "aws_instance" "rh_server1" {
  ami                    = var.redhat_ami_us_east_1
  instance_type          = "t2.micro"
  key_name               = "A4L"
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "rh_server1_tf"
  }
}

resource "aws_instance" "rh_server2" {
  ami                    = var.redhat_ami_us_east_1
  instance_type          = "t2.micro"
  key_name               = "A4L"
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "rh_server2_tf"
  }
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
