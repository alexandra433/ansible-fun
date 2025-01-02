output "server1_ip" {
  value = aws_instance.server1.public_ip
}

output "server1_dns" {
  value = aws_instance.server1.public_dns
}

output "server2_ip" {
  value = aws_instance.server2.public_ip
}

output "server2_dns" {
  value = aws_instance.server2.public_dns
}