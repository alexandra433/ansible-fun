module "testing_servers" {
  source = "./random_modules/test_expect_servers"
}

# AWS SAA stuff
# terraform destroy -target module.a4l_network -target module.a4l_app_instance
module "a4l_network" {
  source = "./a4l_modules/network"
  region = var.aws_region
}

# module "a4l_bastion_host" {
#   source      = "./a4l_modules/bastion_host"
#   vpc_id      = module.a4l_network.vpc_id
#   sn_web_A_id = module.a4l_network.sn_web_A_id
# }

module "a4l_app_instance" {
  source         = "./a4l_modules/app_instance"
  vpc_id         = module.a4l_network.vpc_id
  app_subnet_ids = module.a4l_network.sn_app_ids
  region         = var.aws_region
}