# AWS Infrastructure Terraform Project

This project is designed to provision a scalable and secure AWS infrastructure using Terraform. It includes various components such as networking, compute resources, storage, IAM roles, RDS, security configurations, monitoring, and CI/CD integration.

## Project Structure

The project consists of the following files:

- **backend.tf**: Configures the backend for Terraform state management, using S3 for storage and DynamoDB for state locking.
- **compute.tf**: Defines the Auto Scaling Group for EC2 instances located in private subnets, including instance configurations and scaling policies.
- **database.tf**: Sets up a PostgreSQL RDS instance in a private subnet, along with subnet group and parameter group configurations.
- **iam.tf**: Creates IAM roles for EC2, ALB, and Terraform, ensuring least privilege access.
- **loadbalancer.tf**: Provisions an Application Load Balancer (ALB) that routes traffic to the EC2 instances in the Auto Scaling Group.
- **main.tf**: Serves as the entry point for the Terraform configuration, integrating all defined resources.
- **monitoring.tf**: Configures CloudWatch metrics, log groups, alarms, and dashboards for infrastructure monitoring.
- **network.tf**: Defines networking components, including a VPC, public and private subnets across two Availability Zones (AZs), NAT Gateway, Internet Gateway, and Route Tables.
- **outputs.tf**: Specifies the outputs of the Terraform configuration for referencing resource attributes post-deployment.
- **policies/opa.rego**: Contains OPA/Rego policy definitions for enforcing security policies, such as denying open ports and requiring encryption.
- **provider.tf**: Specifies the provider configuration for AWS, including region and access credentials.
- **security.tf**: Defines security groups, Network ACLs (NACLs), and KMS encryption settings for S3 and RDS.
- **storage.tf**: Provisions an S3 bucket for assets, enabling versioning and setting the appropriate bucket policy.
- **variables.tf**: Declares input variables for the Terraform configuration, allowing for resource parameterization.
- **.github/workflows/terraform.yml**: Contains the GitHub Actions workflow configuration for CI/CD, triggering deployments when .tf files are pushed to the repository.

## Setup Instructions

1. **Install Terraform**: Ensure you have Terraform installed on your local machine.
2. **Configure AWS Credentials**: Set up your AWS credentials using the AWS CLI or environment variables.
3. **Initialize Terraform**: Run `terraform init` in the project directory to initialize the Terraform configuration.
4. **Plan the Deployment**: Execute `terraform plan` to review the resources that will be created.
5. **Apply the Configuration**: Run `terraform apply` to provision the infrastructure.

## Monitoring and Maintenance

- Use CloudWatch to monitor the performance and health of your resources.
- Regularly review IAM roles and policies to ensure least privilege access.
- Update the Terraform configuration as needed and reapply to manage changes in the infrastructure.

## CI/CD Integration

This project includes a CI/CD pipeline configured with GitHub Actions. Changes to the `.tf` files will trigger the deployment process automatically.

## License

This project is licensed under the MIT License. See the LICENSE file for more details.