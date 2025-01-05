resource "aws_instance" "a4l_internal_tf" {
  ami                    = "ami-01816d07b1128cd2d" # AZlinux
  instance_type          = "t2.micro"
  key_name               = "A4L"
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  subnet_id              = var.app_subnet_ids["subA"]
  iam_instance_profile   = aws_iam_instance_profile.ssm_profile.name

  tags = {
    Name = "A4L-INTERNAL-TEST_tf"
  }

  depends_on = [
    aws_vpc_endpoint.ec2,
    aws_vpc_endpoint.s3,
    aws_vpc_endpoint.ec2messages,
    aws_vpc_endpoint.ssmmessages,
    aws_vpc_endpoint.ssm
  ]
}

resource "aws_security_group" "app_sg" {
  name        = "A4L-INTERNAL-TEST-SG"
  description = "Allow ssh inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_id

  tags = {
    Name = "app_sg_tf"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.app_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22
}

resource "aws_vpc_security_group_ingress_rule" "self_ref" {
  security_group_id = aws_security_group.app_sg.id

  referenced_security_group_id = aws_security_group.app_sg.id
  ip_protocol                  = "-1"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.app_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
  security_group_id = aws_security_group.app_sg.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# https://docs.aws.amazon.com/prescriptive-guidance/latest/patterns/connect-to-an-amazon-ec2-instance-by-using-session-manager.html
resource "aws_iam_instance_profile" "ssm_profile" {
  name = "ssm_profile_tf"
  role = aws_iam_role.session_manager_role.name
}

resource "aws_iam_role" "session_manager_role" {
  name = "SessionManagerRole_tf"
  # Gives entities permissions to assume this role
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_policy" {
  role       = aws_iam_role.session_manager_role.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_vpc_endpoint" "ssm" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.ssm"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [var.app_subnet_ids["subA"], var.app_subnet_ids["subB"], var.app_subnet_ids["subC"]]
  security_group_ids  = [aws_security_group.app_sg.id]
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "ec2" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.ec2"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [var.app_subnet_ids["subA"], var.app_subnet_ids["subB"], var.app_subnet_ids["subC"]]
  security_group_ids  = [aws_security_group.app_sg.id]
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.ec2messages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [var.app_subnet_ids["subA"], var.app_subnet_ids["subB"], var.app_subnet_ids["subC"]]
  security_group_ids  = [aws_security_group.app_sg.id]
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.ssmmessages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [var.app_subnet_ids["subA"], var.app_subnet_ids["subB"], var.app_subnet_ids["subC"]]
  security_group_ids  = [aws_security_group.app_sg.id]
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway" # default
}