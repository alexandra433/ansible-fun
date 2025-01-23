variable "aws_region" {
  default = "us-east-1"
  type    = string
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