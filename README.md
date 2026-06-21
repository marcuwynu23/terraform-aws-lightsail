# Terraform AWS Lightsail Instance Provisioning

This Terraform project provisions an Amazon Lightsail instance with a static IP using AWS.

---

## Overview

This configuration creates:

- A Lightsail Ubuntu instance
- A static IP address
- Attachment of static IP to the instance

It is designed for simple VPS deployment using AWS Lightsail.

---

## Resources Created

- `aws_lightsail_instance.my_lightsail_instance` – Lightsail VM instance
- `aws_lightsail_static_ip.my_static_ip` – Static IP resource
- `aws_lightsail_static_ip_attachment.my_static_ip_attachment` – Attaches static IP to instance

---

## Prerequisites

Ensure the following are installed and configured:

- Terraform >= 1.0
- AWS CLI configured (`aws configure`)
- AWS account with Lightsail permissions

Verify installation:

```sh
terraform -v
aws sts get-caller-identity
```

---

## File Structure

```
.
├── main.tf
└── README.md
```

---

## Configuration Details

### Provider

AWS region is set to:

```
ap-southeast-1
```

You can change it based on your preferred region.

---

### Lightsail Instance

- Name: `my-lightsail-instance`
- Blueprint: `ubuntu_20_04`
- Bundle: `micro_2_0`
- Availability Zone: `ap-southeast-1a`

---

### Static IP

A static IP is created and attached to the instance to ensure a stable public IP address.

---

## Usage

### 1. Initialize Terraform

```sh
terraform init
```

---

### 2. Validate Configuration

```sh
terraform validate
```

---

### 3. Preview Changes

```sh
terraform plan
```

---

### 4. Apply Configuration

```sh
terraform apply -auto-approve
```

This will:

- Create Lightsail instance
- Allocate static IP
- Attach static IP to instance

---

### 5. Destroy Infrastructure (optional)

```sh
terraform destroy -auto-approve
```

---

## Outputs

After deployment, Terraform outputs:

- `instance_public_ip` – Public static IP of Lightsail instance

Example:

```
instance_public_ip = "13.xxx.xxx.xxx"
```

---

## Usage as a Module

Reference this repository as a Terraform module in your own configurations:

```hcl
module "lightsail" {
  source = "github.com/marcuwynu23/terraform-aws-lightsail?ref=main"
}
```

Then use the outputs in your configuration:

```hcl
# Example: reference the public IP in a DNS record
resource "aws_route53_record" "instance" {
  zone_id = var.zone_id
  name    = "app"
  type    = "A"
  ttl     = "300"
  records = [module.lightsail.instance_public_ip]
}
```

All outputs documented below are available when using this as a module.

---

## SSH Access

Once deployed, connect using:

```sh
ssh -i <private_key_file> ubuntu@<instance_public_ip>
```

---

## Notes

- Ensure Lightsail instance region matches provider region
- Blueprint IDs and bundle IDs are AWS-specific and must be valid
- Static IP ensures IP does not change on restart
- Uncomment `key_pair_name` if SSH key is configured in Lightsail

---

## Common Issues

### Instance not accessible

- Ensure SSH port (22) is allowed in Lightsail networking
- Verify correct key pair usage

### Invalid blueprint or bundle

- Check AWS Lightsail supported images and instance sizes

---

## Cleanup

To remove all resources:

```sh
terraform destroy -auto-approve
```

---

## Summary

This Terraform setup provides a simple Lightsail VPS deployment with:

- Ubuntu instance provisioning
- Static IP attachment
- Easy SSH access
- Minimal configuration for quick deployment
