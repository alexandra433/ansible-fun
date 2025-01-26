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

variable "host_config_map" {
  type = map(object({
    default_aws_usr = string
    sudo_group      = string
    ssh_service     = string
  }))
  default = {
    debian = {
      default_aws_usr = "admin"
      sudo_group      = "sudo"
      ssh_service     = "ssh"
    }
    redhat = {
      default_aws_usr = "ec2-user"
      sudo_group      = "wheel"
      ssh_service     = "sshd"
    }
  }
}

variable "vault_pass" {
  type        = string
  description = "Vault password for Ansible server"
  sensitive   = true
}

variable "ansible_usr_pass" {
  type        = string
  description = "Password for ansible_usr"
  sensitive   = true
}