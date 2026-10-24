terraform {
  required_version = ">= 1.7.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  # Deliberate guard: a real AWS account must not be targeted by this exercise.
  # Mock-provider tests bypass real AWS authentication and account lookups.
  allowed_account_ids = ["000000000000"]
}
