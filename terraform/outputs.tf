output "test_server1_ip" {
  value = module.testing_servers.server1_ip
}

output "test_server1_dns" {
  value = module.testing_servers.server1_dns
}

output "test_server2_ip" {
  value = module.testing_servers.server2_ip
}

output "test_server2_dns" {
  value = module.testing_servers.server2_dns
}

# animals4life

output "a4l_vpc_ipv6" {
  value = module.a4l_network.vpc_ipv6
}