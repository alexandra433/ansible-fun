variable "region" {
  type    = string
  default = "us-east-1"
}

variable "subnets_map" {
  type = map(object({
    name              = string
    availability_zone = string
    cidr_block_ipv4   = string
    cidr_block_ipv6   = string
  }))
  default = {
    sn-reserved-A = {
      name              = "sn-reserved-A"
      availability_zone = "a"
      cidr_block_ipv4   = "10.16.0.0/20"
      cidr_block_ipv6   = "00::/64"
    }
    sn-db-A = {
      name              = "sn-db-A"
      availability_zone = "a"
      cidr_block_ipv4   = "10.16.16.0/20"
      cidr_block_ipv6   = "01::/64"
    }
    sn-app-A = {
      name              = "sn-app-A"
      availability_zone = "a"
      cidr_block_ipv4   = "10.16.32.0/20"
      cidr_block_ipv6   = "02::/64"
    }
    sn-web-A = {
      name              = "sn-web-A"
      availability_zone = "a"
      cidr_block_ipv4   = "10.16.48.0/20"
      cidr_block_ipv6   = "03::/64"
    }
    sn-reserved-B = {
      name              = "sn-reserved-B"
      availability_zone = "b"
      cidr_block_ipv4   = "10.16.64.0/20"
      cidr_block_ipv6   = "04::/64"
    }
    sn-db-B = {
      name              = "sn-db-B"
      availability_zone = "b"
      cidr_block_ipv4   = "10.16.80.0/20"
      cidr_block_ipv6   = "05::/64"
    }
    sn-app-B = {
      name              = "sn-app-B"
      availability_zone = "b"
      cidr_block_ipv4   = "10.16.96.0/20"
      cidr_block_ipv6   = "06::/64"
    }
    sn-web-B = {
      name              = "sn-web-B"
      availability_zone = "b"
      cidr_block_ipv4   = "10.16.112.0/20"
      cidr_block_ipv6   = "07::/64"
    }
    sn-reserved-C = {
      name              = "sn-reserved-C"
      availability_zone = "c"
      cidr_block_ipv4   = "10.16.128.0/20"
      cidr_block_ipv6   = "08::/64"
    }
    sn-db-C = {
      name              = "sn-db-C"
      availability_zone = "c"
      cidr_block_ipv4   = "10.16.144.0/20"
      cidr_block_ipv6   = "09::/64"
    }
    sn-app-C = {
      name              = "sn-app-C"
      availability_zone = "c"
      cidr_block_ipv4   = "10.16.160.0/20"
      cidr_block_ipv6   = "0A::/64"
    }
    sn-web-C = {
      name              = "sn-web-C"
      availability_zone = "c"
      cidr_block_ipv4   = "10.16.176.0/20"
      cidr_block_ipv6   = "0B::/64"
    }
  }
}