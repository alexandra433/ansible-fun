# Ansible stuff
output "rh_server1_ip" {
  value = module.testing_servers.rh_server1_ip
}

output "rh_server1_dns" {
  value = module.testing_servers.rh_server1_dns
}

output "rh_server2_ip" {
  value = module.testing_servers.rh_server2_ip
}

output "rh_server2_dns" {
  value = module.testing_servers.rh_server2_dns
}

output "deb_server1_ip" {
  value = module.testing_servers.deb_server1_ip
}

output "deb_server1_dns" {
  value = module.testing_servers.deb_server1_dns
}

output "deb_server2_ip" {
  value = module.testing_servers.deb_server2_ip
}

output "deb_server2_dns" {
  value = module.testing_servers.deb_server2_dns
}