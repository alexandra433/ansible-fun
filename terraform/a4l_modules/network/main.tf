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
  map_public_ip_on_launch         = each.value.is_public

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

resource "aws_route_table_association" "rta-web" {
  # would like this to just be a list like ["sn-web-A", "sn-web-B", "sn-web-C"] instead of a map
  for_each = { for sn_key, sn_value in var.subnets_map : sn_key => sn_value if sn_value.is_public }

  subnet_id      = aws_subnet.a4l_subnets[each.key].id
  route_table_id = aws_route_table.a4l-vpc1-rt-web.id
}

# NAT Gateways
resource "aws_nat_gateway" "A4L-vpc1-natgw-A" {
  allocation_id = aws_eip.A4L-vpc1-natgw-A-eip.id
  subnet_id     = aws_subnet.a4l_subnets["sn-web-A"].id

  tags = {
    Name = "A4L-vpc1-natgw-A_tf"
  }

  # from docs
  depends_on = [aws_internet_gateway.a4l-vpc1-igw]
}

resource "aws_eip" "A4L-vpc1-natgw-A-eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "A4L-vpc1-natgw-B" {
  allocation_id = aws_eip.A4L-vpc1-natgw-B-eip.id
  subnet_id     = aws_subnet.a4l_subnets["sn-web-B"].id

  tags = {
    Name = "A4L-vpc1-natgw-B_tf"
  }

  # from docs
  depends_on = [aws_internet_gateway.a4l-vpc1-igw]
}

resource "aws_eip" "A4L-vpc1-natgw-B-eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "A4L-vpc1-natgw-C" {
  allocation_id = aws_eip.A4L-vpc1-natgw-C-eip.id
  subnet_id     = aws_subnet.a4l_subnets["sn-web-C"].id

  tags = {
    Name = "A4L-vpc1-natgw-C_tf"
  }

  # from docs
  depends_on = [aws_internet_gateway.a4l-vpc1-igw]
}

resource "aws_eip" "A4L-vpc1-natgw-C-eip" {
  domain = "vpc"
}


resource "aws_route_table" "a4l-vpc1-rt-private-A" {
  vpc_id = aws_vpc.a4l_vpc1.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.A4L-vpc1-natgw-A.id
  }

  tags = {
    Name = "a4l-vpc1-rt-private-A-tf"
  }
}

resource "aws_route_table" "a4l-vpc1-rt-private-B" {
  vpc_id = aws_vpc.a4l_vpc1.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.A4L-vpc1-natgw-B.id
  }

  tags = {
    Name = "a4l-vpc1-rt-private-B-tf"
  }
}

resource "aws_route_table" "a4l-vpc1-rt-private-C" {
  vpc_id = aws_vpc.a4l_vpc1.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.A4L-vpc1-natgw-C.id
  }

  tags = {
    Name = "a4l-vpc1-rt-private-C-tf"
  }
}

resource "aws_route_table_association" "app-rta-a" {
  subnet_id      = aws_subnet.a4l_subnets["sn-app-A"].id
  route_table_id = aws_route_table.a4l-vpc1-rt-private-A.id
}

resource "aws_route_table_association" "app-rta-b" {
  subnet_id      = aws_subnet.a4l_subnets["sn-app-B"].id
  route_table_id = aws_route_table.a4l-vpc1-rt-private-B.id
}

resource "aws_route_table_association" "app-rta-c" {
  subnet_id      = aws_subnet.a4l_subnets["sn-app-C"].id
  route_table_id = aws_route_table.a4l-vpc1-rt-private-C.id
}

resource "aws_route_table_association" "reserved-rta-a" {
  subnet_id      = aws_subnet.a4l_subnets["sn-reserved-A"].id
  route_table_id = aws_route_table.a4l-vpc1-rt-private-A.id
}

resource "aws_route_table_association" "reserved-rta-b" {
  subnet_id      = aws_subnet.a4l_subnets["sn-reserved-B"].id
  route_table_id = aws_route_table.a4l-vpc1-rt-private-B.id
}

resource "aws_route_table_association" "reserved-rta-c" {
  subnet_id      = aws_subnet.a4l_subnets["sn-reserved-C"].id
  route_table_id = aws_route_table.a4l-vpc1-rt-private-C.id
}

resource "aws_route_table_association" "db-rta-a" {
  subnet_id      = aws_subnet.a4l_subnets["sn-db-A"].id
  route_table_id = aws_route_table.a4l-vpc1-rt-private-A.id
}

resource "aws_route_table_association" "db-rta-b" {
  subnet_id      = aws_subnet.a4l_subnets["sn-db-B"].id
  route_table_id = aws_route_table.a4l-vpc1-rt-private-B.id
}

resource "aws_route_table_association" "db-rta-c" {
  subnet_id      = aws_subnet.a4l_subnets["sn-db-C"].id
  route_table_id = aws_route_table.a4l-vpc1-rt-private-C.id
}