variable "vpc_id" {
  type = string
}

variable "app_subnet_ids" {
  type = map(string)
}

variable "region" {
  type    = string
  default = "us-east-1"
}
