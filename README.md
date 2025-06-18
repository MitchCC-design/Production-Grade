# AWS Production-Grade Infrastructure with Terraform

This repository contains a comprehensive, production-ready Terraform configuration for provisioning a secure, scalable, and highly available AWS infrastructure. It is designed for modern cloud-native applications and incorporates best practices for security, automation, monitoring, and compliance.

---

## Architecture Overview

This project provisions the following AWS resources and configurations:

- **Networking:**  
  - A dedicated VPC with custom CIDR, spanning two Availability Zones (AZs).
  - Two public and two private subnets distributed across AZs for high availability.
  - Internet Gateway for public subnet internet access.
  - NAT Gateway (with Elastic IP) for secure outbound internet access from private subnets.
  - Route tables and associations to control traffic flow.
  - Network ACLs for additional subnet-level security.

- **Compute:**  
  - Auto Scaling Group (ASG) of EC2 instances, deployed in private subnets for security.
  - Launch Template specifying AMI, instance type, IAM profile, security groups, and user data.
  - Application Load Balancer (ALB) in public subnets, routing HTTP(S) traffic to EC2 instances.
  - Target Group and Listener for ALB.

- **Storage:**  
  - S3 bucket for static assets, with versioning and server-side encryption using a dedicated KMS key.
  - S3 bucket policy enforcing secure (HTTPS) access and optional public access restrictions.

- **Database:**  
  - PostgreSQL RDS instance, deployed in private subnets for isolation.
  - Custom DB subnet group and parameter group.
  - RDS encryption at rest using a dedicated KMS key.
  - Security group restricting access to only application EC2 instances.

- **IAM & Security:**  
  - Least-privilege IAM roles for EC2, ALB, and Terraform automation.
  - Instance profiles for EC2.
  - Security groups for ALB, EC2, and RDS, with tightly scoped ingress/egress rules.
  - KMS keys for S3 and RDS encryption.
  - Network ACLs for subnet-level traffic filtering.

- **Monitoring & Logging:**  
  - CloudWatch Log Group for application and infrastructure logs.
  - CloudWatch Metric Alarm for EC2 ASG CPU utilization.
  - CloudWatch Dashboard visualizing key metrics.

- **CI/CD & Policy Enforcement:**  
  - GitHub Actions workflow for automated Terraform formatting, validation, security scanning (Checkov), and planning.
  - OPA/Rego and Checkov policies for enforcing security/compliance (e.g., no open ports, mandatory encryption).
  - Remote Terraform state stored in S3 with DynamoDB for state locking and consistency.

---

## Project Structure

| File/Directory                       | Purpose                                                                                  |
|--------------------------------------|------------------------------------------------------------------------------------------|
| `backend.tf`                         | Configures remote state backend (S3 + DynamoDB) for safe, collaborative Terraform usage. |
| `compute.tf`                         | Defines EC2 Auto Scaling Group, Launch Template, and instance profile.                   |
| `database.tf`                        | Provisions RDS PostgreSQL, subnet group, parameter group, and KMS key.                   |
| `iam.tf`                             | Declares IAM roles and policies for EC2, ALB, and Terraform.                             |
| `loadbalancer.tf`                    | Sets up Application Load Balancer, Target Group, and Listener.                           |
| `monitoring.tf`                      | Configures CloudWatch Log Group, alarms, and dashboard.                                  |
| `network.tf`                         | Provisions VPC, subnets, gateways, route tables, and NACLs.                              |
| `outputs.tf`                         | Exposes key resource attributes (ALB DNS, S3 bucket, RDS endpoint, etc.).                |
| `policies/opa.rego`                  | OPA/Rego policy definitions for infrastructure compliance.                               |
| `policies/checkov.yml`               | Checkov configuration for security scanning.                                             |
| `provider.tf`                        | AWS provider configuration (region, credentials).                                        |
| `security.tf`                        | Security groups, NACLs, and KMS key resources.                                           |
| `storage.tf`                         | S3 bucket for assets, versioning, encryption, and bucket policy.                         |
| `variables.tf`                       | Input variables for all configurable parameters.                                         |
| `.github/workflows/terraform.yml`     | GitHub Actions workflow for CI/CD and policy enforcement.                                |
| `README.md`                          | This documentation file.                                                                 |

---

## Deployment Workflow

1. **Install Prerequisites**
   - [Terraform](https://www.terraform.io/downloads.html)
   - [AWS CLI](https://aws.amazon.com/cli/)
   - AWS credentials configured via environment variables or `~/.aws/credentials`.

2. **Clone the Repository**
   ```sh
   git clone git@github.com:MitchCC-design/Production-Grade.git
   cd Production-Grade/aws-infra-terraform
   ```

3. **Configure Variables**
   - Edit `variables.tf` or use a `terraform.tfvars` file to set values for:
     - `aws_region`
     - `assets_bucket_name`
     - `db_username`
     - `db_password`
     - (and any other variables as needed)

4. **Initialize Terraform**
   ```sh
   terraform init
   ```

5. **Review the Plan**
   ```sh
   terraform plan
   ```

6. **Apply the Configuration**
   ```sh
   terraform apply
   ```
   - Review and confirm the proposed changes.

7. **CI/CD Integration**
   - On every push to `.tf` files, GitHub Actions will:
     - Check formatting (`terraform fmt`)
     - Validate configuration (`terraform validate`)
     - Run security scans (`checkov`)
     - Generate a plan (`terraform plan`)
   - Policy-as-code (OPA/Rego, Checkov) ensures compliance before changes are applied.

---

## Security & Compliance Highlights

- **All sensitive resources are private:**  
  EC2 and RDS are only accessible within private subnets.
- **Encryption everywhere:**  
  S3 and RDS use customer-managed KMS keys for encryption at rest.
- **Least privilege IAM:**  
  Roles grant only the permissions required for each service.
- **Defense in depth:**  
  Security groups, NACLs, and bucket policies restrict access at multiple layers.
- **Automated policy enforcement:**  
  OPA/Rego and Checkov prevent misconfigurations (e.g., open ports, unencrypted storage).
- **Immutable infrastructure:**  
  Versioning and `prevent_destroy` lifecycle rules protect critical resources.

---

## Monitoring & Operations

- **CloudWatch Log Group:**  
  Centralized logging for application and infrastructure events.
- **CloudWatch Alarms:**  
  Automated alerts for high CPU or other metrics.
- **CloudWatch Dashboard:**  
  Visualizes key metrics for operational insight.
- **Outputs:**  
  After deployment, Terraform outputs endpoints and resource names for integration.

---

## Maintenance & Best Practices

- **Review IAM roles and policies regularly.**
- **Monitor CloudWatch dashboards and alarms.**
- **Keep Terraform and AWS provider plugins up to date.**
- **Use pull requests and CI/CD to manage infrastructure changes.**
- **Regularly back up and secure your Terraform state files.**

---

## Extending This Project

- **Add more environments:**  
  Use [Terraform workspaces](https://developer.hashicorp.com/terraform/language/state/workspaces) or separate state files for dev/staging/prod.
- **Add more services:**  
  Integrate Lambda, API Gateway, ECS, etc., as needed.
- **Modularize:**  
  Refactor resources into reusable modules for larger teams or organizations.
- **Enhance security:**  
  Add VPC endpoints, WAF, GuardDuty, or more granular NACL rules.

---

## License

This project is licensed under the MIT License. See the [LICENSE](./LICENSE) file for details.

---

## Support

For questions, issues, or contributions, please open an issue or pull request on [GitHub](https://github.com/MitchCC-design/Production-Grade).

---