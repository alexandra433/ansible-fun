variable "redhat_ami_us_east_1" {
  type    = string
  default = "ami-0c7af5fe939f2677f" # redhat free tier
}

variable "debian_ami_us_east_1" {
  type    = string
  default = "ami-064519b8c76274859" # debian 12 free tier
}

variable "ubuntu_ami_us_east_1" {
  type    = string
  default = "ami-0e2c8caa4b6378d8c" # ubuntu free tier
}

variable "azlinux_ami_us_east_1" {
  type    = string
  default = "ami-01816d07b1128cd2d" # AZlinux free tier
}