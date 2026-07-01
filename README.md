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

## Remote State Management (S3 Backend)

This module uses AWS S3 as the Terraform backend for remote state management with DynamoDB for state locking.

### Create the Backend Resources

Run the following commands once per AWS account to create the bucket and lock table:

```bash
# Create S3 bucket for Terraform state
aws s3api create-bucket \
  --bucket your-terraform-state-bucket \
  --region ap-southeast-1 \
  --create-bucket-configuration LocationConstraint=ap-southeast-1

# Enable versioning on the bucket
aws s3api put-bucket-versioning \
  --bucket your-terraform-state-bucket \
  --versioning-configuration Status=Enabled

# Create DynamoDB table for state locking
aws dynamodb create-table \
  --table-name terraform-state-lock \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region ap-southeast-1
```

### Configure the Backend

Create a `backend.tfvars` file:

```hcl
bucket         = "your-terraform-state-bucket"
key            = "lightsail/terraform.tfstate"
region         = "ap-southeast-1"
dynamodb_table = "terraform-state-lock"
encrypt        = true
```

Initialize with the backend config:

```bash
terraform init -backend-config="backend.tfvars"
```

### GitHub Actions CI/CD

Two workflows are available for automated deployment:

| Workflow | Description |
|----------|-------------|
| `terraform-cd-apply.yml` | Plan and provision infrastructure |
| `terraform-cd-destroy.yml` | Tear down infrastructure |

#### Required GitHub Secrets

| Secret | Description |
|--------|-------------|
| `AWS_ACCESS_KEY_ID` | AWS access key ID |
| `AWS_SECRET_ACCESS_KEY` | AWS secret access key |
| `TF_STATE_BUCKET` | S3 bucket name for Terraform state |
| `TF_STATE_REGION` | AWS region for the state bucket |
| `TF_STATE_LOCK_TABLE` | DynamoDB table for state locking |

## Common Issues

### Instance not accessible
- Ensure SSH port (22) is allowed in Lightsail networking
- Verify correct key pair usage

### Invalid blueprint or bundle
- Check AWS Lightsail supported images and instance sizes
