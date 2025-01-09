output "rh_server1_ip" {
  value = aws_instance.rh_server1.public_ip
}

output "rh_server1_dns" {
  value = aws_instance.rh_server1.public_dns
}

output "rh_server2_ip" {
  value = aws_instance.rh_server2.public_ip
}

output "rh_server2_dns" {
  value = aws_instance.rh_server2.public_dns
}

output "deb_server1_ip" {
  value = aws_instance.deb_server1.public_ip
}

output "deb_server1_dns" {
  value = aws_instance.deb_server1.public_dns
}

output "deb_server2_ip" {
  value = aws_instance.deb_server2.public_ip
}

output "deb_server2_dns" {
  value = aws_instance.deb_server2.public_dns
}