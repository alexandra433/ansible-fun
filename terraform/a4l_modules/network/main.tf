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

  vpc_id            = aws_vpc.a4l_vpc1.id
  availability_zone = "${region} + each.value.availability_zone"
  cidr_block        = each.value.cidr_block_ipv4
  ipv6_cidr_block   = aws_vpc.a4l_vpc1.ipv6_cidr_block + each.value.cidr_block_ipv6

  tags = {
    Name = each.key
  }
}