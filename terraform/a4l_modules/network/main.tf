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