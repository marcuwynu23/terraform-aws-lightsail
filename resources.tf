
# Create a Lightsail instance
resource "aws_lightsail_instance" "my_lightsail_instance" {
  name              = "my-lightsail-instance"
  availability_zone = "ap-southeast-1a" # Choose your availability zone
  blueprint_id      = "ubuntu_20_04"    # The blueprint ID (Ubuntu in this case)
  bundle_id         = "micro_2_0"       # Instance size, choose appropriate one for your need

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
