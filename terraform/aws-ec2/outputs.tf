output "public_ip" {
  value       = aws_instance.example_http_instance.public_ip
  description = "Public IP of the EC2 instance"
}

output "public_nds" {
  value       = aws_instance.example_http_instance.public_dns
  description = "Public DNS of the EC2 instance"
}
