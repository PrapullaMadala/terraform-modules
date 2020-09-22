terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 3.1.0"
        }
    }
}

provider "aws" {
  profile  = var.aws_profile
  region = var.region
}
