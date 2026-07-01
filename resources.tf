
# Create a Lightsail instance
resource "aws_lightsail_instance" "my_lightsail_instance" {
  name              = var.instance_name
  availability_zone = var.availability_zone
  blueprint_id      = var.blueprint_id
  bundle_id         = var.bundle_id

  # key_pair_name = "marcuwynu23-aws" # Make sure this SSH key exists
  tags = {
    Name = "MyLightsailInstance"
  }
}

# Create a Static IP for the instance
resource "aws_lightsail_static_ip" "my_static_ip" {
  name = "my-static-ip"
}

# Attach the Static IP to the instance
resource "aws_lightsail_static_ip_attachment" "my_static_ip_attachment" {
  static_ip_name = aws_lightsail_static_ip.my_static_ip.name
  instance_name  = aws_lightsail_instance.my_lightsail_instance.name
}
