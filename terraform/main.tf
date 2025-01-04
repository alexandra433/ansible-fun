module "testing_servers" {
  source = "./random_modules/test_expect_servers"
}

# AWS SAA stuff
module "a4l_network" {
  source = "./a4l_modules/network"
  region = var.aws_region
}

module "a4l_bastion_host" {
  source      = "./a4l_modules/bastion_host"
  vpc_id      = module.a4l_network.vpc_id
  sn_web_A_id = module.a4l_network.sn_web_A_id
}