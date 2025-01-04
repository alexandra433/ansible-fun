resource "aws_instance" "bastion_host" {
  ami                    = "ami-01816d07b1128cd2d" # AZlinux
  instance_type          = "t2.micro"
  key_name               = "A4L"
  vpc_security_group_ids = [aws_security_group.A4L_bastion_sg.id]
  subnet_id              = var.sn_web_A_id

  tags = {
    Name = "a4l_bastion_host_tf"
  }
}

resource "aws_security_group" "A4L_bastion_sg" {
  name        = "A4L_bastion_sg"
  description = "Allow ssh inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_id

  tags = {
    Name = "A4L_bastion_sg_tf"
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
