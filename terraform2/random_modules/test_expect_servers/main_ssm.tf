resource "aws_ssm_parameter" "vault_pass" {
  name        = "/ansible_server/ansible_vault_pass_tf" # hierarchical structure
  type        = "SecureString"                          # default kms key will be used
  value       = var.vault_pass
  description = "Vault password for the ansible server"
}

resource "aws_ssm_parameter" "ansible_usr_pass" {
  name        = "/managed_host/ansible_vault_pass_tf"
  type        = "SecureString"
  value       = var.ansible_usr_pass
  description = "Password for ansible_usr on the ansible-managed hosts"
}