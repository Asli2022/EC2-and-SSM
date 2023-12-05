output "instance_id" {
  description = "The ID of the created EC2 instance."
  value       = aws_instance.web-server.id
}

output "public_ip" {
  description = "The public IP address of the created EC2 instance."
  value       = aws_instance.web-server.public_ip
}

output "security_group_id" {
  description = "The ID of the created security group."
  value       = aws_security_group.web-server_sg.id
}

