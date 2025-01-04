output "vpc_ipv6" {
  value = aws_vpc.a4l_vpc1.ipv6_cidr_block
}

output "vpc_id" {
  value = aws_vpc.a4l_vpc1.id
}

output "sn_web_A_id" {
  value = aws_subnet.a4l_subnets["sn-web-A"].id
}