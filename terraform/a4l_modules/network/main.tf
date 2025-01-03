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
  availability_zone = join("", [var.region, each.value.availability_zone])
  cidr_block        = each.value.cidr_block_ipv4
  # https://developer.hashicorp.com/terraform/language/functions/replace
  ipv6_cidr_block = join("", [replace(aws_vpc.a4l_vpc1.ipv6_cidr_block, "/00::/56/", ""), each.value.cidr_block_ipv6])

  tags = {
    Name = each.key
    Type = "a4l_subnet"
  }
}