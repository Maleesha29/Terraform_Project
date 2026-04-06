# Terraform Project (AWS)

This repo provisions a simple AWS web stack using Terraform:

- VPC
- 2 public subnets (in 2 AZs)
- Internet Gateway + route table associations
- Security Group (HTTP/SSH)
- 2 EC2 instances (Apache via `userdata.sh`)
- Application Load Balancer + target group + listener
- S3 bucket

## Prerequisites

- Terraform installed
- AWS credentials configured (e.g. `aws configure`, environment variables, or an AWS profile)

## How to run

```bash
terraform init
terraform plan
terraform apply
```

After apply, Terraform prints an output named `loadbalancerdns`.

## Clean up

```bash
terraform destroy
```

## Notes

- Do **not** commit `terraform.tfstate` (already ignored via `.gitignore`).
- The S3 bucket name must be globally unique (see `variables.tf`).
