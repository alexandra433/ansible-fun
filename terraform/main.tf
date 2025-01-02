module "testing_servers" {
  source = "./random_modules/test_expect_servers"
}

module "a4l_network" {
  source = "./a4l_modules/network"
  region = var.aws_region
}