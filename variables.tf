variable "instance_name" {
  description = "Name of the Lightsail instance"
  type        = string
  default     = "my-lightsail-instance"
}

variable "availability_zone" {
  description = "Availability zone for the Lightsail instance"
  type        = string
  default     = "ap-southeast-1a"
}

variable "blueprint_id" {
  description = "Blueprint ID (OS/image) for the Lightsail instance"
  type        = string
  default     = "ubuntu_20_04"
}

variable "bundle_id" {
  description = "Bundle ID (instance size) for the Lightsail instance"
  type        = string
  default     = "micro_2_0"
}
