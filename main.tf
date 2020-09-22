terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.1.0"
    }
  }
}

provider "aws" {
  region = var.region
}

module "vpc-security" {
  source               = "./vpc-security"
  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
  igw_cidr             = "0.0.0.0/0"
}