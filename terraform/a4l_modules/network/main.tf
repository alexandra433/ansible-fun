resource "aws_vpc" "a4l_vpc1" {
  cidr_block                       = "10.16.0.0/16"
  instance_tenancy                 = "default"
  assign_generated_ipv6_cidr_block = true
  enable_dns_hostnames             = true
  enable_dns_support               = true

  tags = {
    Name = "a4l_vpc1_tf"
  }
}

resource "aws_subnet" "a4l_subnets" {
  for_each = var.subnets_map

  vpc_id                          = aws_vpc.a4l_vpc1.id
  availability_zone               = join("", [var.region, each.value.availability_zone])
  cidr_block                      = each.value.cidr_block_ipv4
  ipv6_cidr_block                 = join("", [replace(aws_vpc.a4l_vpc1.ipv6_cidr_block, "/00::/56/", ""), each.value.cidr_block_ipv6])
  assign_ipv6_address_on_creation = true
  map_public_ip_on_launch         = each.value.auto_assign_ipv4

  tags = {
    Name = each.key
    Type = "a4l_subnet"
  }
}

resource "aws_internet_gateway" "a4l-vpc1-igw" {
  vpc_id = aws_vpc.a4l_vpc1.id

  tags = {
    Name = "a4l-vpc1-igw_tf"
  }
}

resource "aws_route_table" "a4l-vpc1-rt-web" {
  vpc_id = aws_vpc.a4l_vpc1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.a4l-vpc1-igw.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.a4l-vpc1-igw.id
  }

  tags = {
    Name = "a4l-vpc1-rt-web-tf"
  }
}

resource "aws_route_table_association" "rta-a" {
  subnet_id      = aws_subnet.a4l_subnets["sn-web-A"].id
  route_table_id = aws_route_table.a4l-vpc1-rt-web.id
}

resource "aws_route_table_association" "rta-b" {
  subnet_id      = aws_subnet.a4l_subnets["sn-web-B"].id
  route_table_id = aws_route_table.a4l-vpc1-rt-web.id
}

resource "aws_route_table_association" "rta-c" {
  subnet_id      = aws_subnet.a4l_subnets["sn-web-C"].id
  route_table_id = aws_route_table.a4l-vpc1-rt-web.id
}