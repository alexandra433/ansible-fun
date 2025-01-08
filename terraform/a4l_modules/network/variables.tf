variable "region" {
  type    = string
  default = "us-east-1"
}

variable "subnets_map" {
  type = map(object({
    availability_zone = string
    cidr_block_ipv4   = string
    cidr_block_ipv6   = string
    is_public         = bool
  }))
  default = {
    sn-reserved-A = {
      availability_zone = "a"
      cidr_block_ipv4   = "10.16.0.0/20"
      cidr_block_ipv6   = "00::/64"
      is_public         = false
    }
    sn-db-A = {
      availability_zone = "a"
      cidr_block_ipv4   = "10.16.16.0/20"
      cidr_block_ipv6   = "01::/64"
      is_public         = false
    }
    sn-app-A = {
      availability_zone = "a"
      cidr_block_ipv4   = "10.16.32.0/20"
      cidr_block_ipv6   = "02::/64"
      is_public         = false
    }
    sn-web-A = {
      availability_zone = "a"
      cidr_block_ipv4   = "10.16.48.0/20"
      cidr_block_ipv6   = "03::/64"
      is_public         = true
    }
    sn-reserved-B = {
      availability_zone = "b"
      cidr_block_ipv4   = "10.16.64.0/20"
      cidr_block_ipv6   = "04::/64"
      is_public         = false
    }
    sn-db-B = {
      availability_zone = "b"
      cidr_block_ipv4   = "10.16.80.0/20"
      cidr_block_ipv6   = "05::/64"
      is_public         = false
    }
    sn-app-B = {
      availability_zone = "b"
      cidr_block_ipv4   = "10.16.96.0/20"
      cidr_block_ipv6   = "06::/64"
      is_public         = false
    }
    sn-web-B = {
      availability_zone = "b"
      cidr_block_ipv4   = "10.16.112.0/20"
      cidr_block_ipv6   = "07::/64"
      is_public         = true
    }
    sn-reserved-C = {
      availability_zone = "c"
      cidr_block_ipv4   = "10.16.128.0/20"
      cidr_block_ipv6   = "08::/64"
      is_public         = false
    }
    sn-db-C = {
      availability_zone = "c"
      cidr_block_ipv4   = "10.16.144.0/20"
      cidr_block_ipv6   = "09::/64"
      is_public         = false
    }
    sn-app-C = {
      availability_zone = "c"
      cidr_block_ipv4   = "10.16.160.0/20"
      cidr_block_ipv6   = "0a::/64"
      is_public         = false
    }
    sn-web-C = {
      availability_zone = "c"
      cidr_block_ipv4   = "10.16.176.0/20"
      cidr_block_ipv6   = "0b::/64"
      is_public         = true
    }
  }
}