
# Output the public IP of the instance
output "instance_public_ip" {
  value       = aws_lightsail_instance.my_lightsail_instance.public_ip_address
  description = "The public IP address of the Lightsail instance."
}

