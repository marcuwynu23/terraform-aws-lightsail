# Terraform AWS Lightsail Instance Provisioning

This Terraform project provisions an Amazon Lightsail instance with a static IP using AWS.

## Prerequisites

Ensure the following are installed and configured:
- Terraform >= 1.0
- AWS CLI configured (`aws configure`)
- AWS account with Lightsail permissions

Verify:

```bash
aws sts get-caller-identity
```

## Setup & Deployment

1. **Initialize Terraform**:
   ```bash
   terraform init
   ```

2. **Validate Configuration**:
   ```bash
   terraform validate
   ```

3. **Preview Changes**:
   ```bash
   terraform plan
   ```

4. **Apply Configuration**:
   ```bash
   terraform apply -auto-approve
   ```

   This will create a Lightsail instance, allocate a static IP, and attach the static IP to the instance.

5. **SSH Access**:
   ```bash
   ssh -i <private_key_file> ubuntu@<instance_public_ip>
   ```

6. **Destroy** (when no longer needed):
   ```bash
   terraform destroy -auto-approve
   ```

## Usage as a Module

Reference this repository as a Terraform module in your own configurations:

```hcl
module "lightsail" {
  source = "github.com/marcuwynu23/terraform-aws-lightsail?ref=main"
}
```

Then use the outputs in your configuration:

```hcl
resource "aws_route53_record" "instance" {
  zone_id = var.zone_id
  name    = "app"
  type    = "A"
  ttl     = "300"
  records = [module.lightsail.instance_public_ip]
}
```

All outputs documented below are available when using this as a module.

## Variables

This module accepts no configurable variables. Instance name, blueprint, bundle, and availability zone are preconfigured with sensible defaults.

## Outputs

| Output | Description |
|--------|-------------|
| `instance_public_ip` | Public static IP of Lightsail instance |

## Resources Created

- `aws_lightsail_instance.my_lightsail_instance` – Lightsail VM instance (Ubuntu 20.04, micro_2_0)
- `aws_lightsail_static_ip.my_static_ip` – Static IP resource
- `aws_lightsail_static_ip_attachment.my_static_ip_attachment` – Attaches static IP to instance

## Notes

- Ensure Lightsail instance region matches provider region
- Blueprint IDs and bundle IDs are AWS-specific and must be valid
- Static IP ensures IP does not change on restart
- Uncomment `key_pair_name` if SSH key is configured in Lightsail

## Common Issues

### Instance not accessible
- Ensure SSH port (22) is allowed in Lightsail networking
- Verify correct key pair usage

### Invalid blueprint or bundle
- Check AWS Lightsail supported images and instance sizes
