resource "aws_instance" "ansible_server" {
  ami                    = "ami-0e2c8caa4b6378d8c" # ubuntu free tier
  instance_type          = "t2.micro"
  key_name               = "A4L"
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "ansible_server_tf"
  }
}

resource "aws_instance" "server1" {
  ami                    = "ami-064519b8c76274859" # debian free tier
  instance_type          = "t2.micro"
  key_name               = "A4L"
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "server1_tf"
  }
}

resource "aws_instance" "server2" {
  ami                    = "ami-064519b8c76274859" # debian free tier
  instance_type          = "t2.micro"
  key_name               = "A4L"
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "server2_tf"
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
