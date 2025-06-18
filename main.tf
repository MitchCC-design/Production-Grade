terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  required_version = ">= 0.12"
}

provider "aws" {
  region = var.aws_region
}

module "network" {
  source = "./network.tf"
}

module "compute" {
  source = "./compute.tf"
}

module "database" {
  source = "./database.tf"
}

module "iam" {
  source = "./iam.tf"
}

module "loadbalancer" {
  source = "./loadbalancer.tf"
}

module "storage" {
  source = "./storage.tf"
}

module "monitoring" {
  source = "./monitoring.tf"
}

module "security" {
  source = "./security.tf"
}

output "vpc_id" {
  value = module.network.vpc_id
}

output "alb_dns_name" {
  value = module.loadbalancer.alb_dns_name
}

output "rds_endpoint" {
  value = module.database.rds_endpoint
}

variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
}