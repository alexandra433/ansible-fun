output "vpc_ipv6" {
  value = aws_vpc.a4l_vpc1.ipv6_cidr_block
}

output "vpc_id" {
  value = aws_vpc.a4l_vpc1.id
}

output "sn_web_A_id" {
  value = aws_subnet.a4l_subnets["sn-web-A"].id
}

output "sn_app_ids" {
  value = {
    subA = aws_subnet.a4l_subnets["sn-app-A"].id
    subB = aws_subnet.a4l_subnets["sn-app-B"].id
    subC = aws_subnet.a4l_subnets["sn-app-C"].id
  }
}

output "sn_web_ids" {
  value = {
    subA = aws_subnet.a4l_subnets["sn-web-A"].id
    subB = aws_subnet.a4l_subnets["sn-web-B"].id
    subC = aws_subnet.a4l_subnets["sn-web-C"].id
  }
}