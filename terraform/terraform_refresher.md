Terraform was already downloaded and aws configure (iamadmin-general for SAA cert practice)
 - check aws configuration with `aws configure list`

Commands:
-----------------
- terraform fmt -recursive
  - auto format code
- terraform init
- terraform plan
- terraform apply
- terraform destroy

- tflint

20250123
---------------
AWS secrets manager costs money. Protecting sensitive variables with just terraform:
https://developer.hashicorp.com/terraform/tutorials/configuration-language/sensitive-variables


Update: instead of doing the following, just call it terraform.tfvars instead of secrets.tfvars.
Terraform will read that file automatically without you specifying -var-file. Still hidden from git

Created a secrets.tfvars file under root folder.
```
vault_pass = "your_password"
ansible_usr_pass = "your_password"
```
New commands:
 - `terraform plan -var-file="secret.tfvars"`
 - `terraform apply -var-file="secret.tfvars"`
 - `terraform destroy -var-file="secret.tfvars"`

Also:
https://stackoverflow.com/questions/50835636/accessing-terraform-variables-within-user-data-provider-template-file