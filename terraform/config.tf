terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.36.0"
    }
  }
  required_version = "~> 1.7"
}

provider "aws" {
  profile = "iamadmin-general"
  region = var.aws_region
}