variable "aws_region" {
  description = "Region for the isolated deployment exercise."
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "Existing local AWS CLI profile for your personal lab account."
  type        = string
  default     = "admin-lab"
}

variable "expected_account_id" {
  description = "Account verified using STS before planning; set locally, never commit credentials."
  type        = string
  nullable    = false

  validation {
    condition     = can(regex("^[0-9]{12}$", var.expected_account_id)) && var.expected_account_id != "000000000000"
    error_message = "Supply your verified 12-digit lab account ID; the all-zero placeholder is not allowed."
  }
}

variable "project_name" {
  description = "Distinct resource tag and name prefix for the live Terraform lab."
  type        = string
  default     = "guot-tf-network-live"
}

variable "environment" {
  description = "Tag used for the controlled update and drift exercises."
  type        = string
  default     = "learning"
}

variable "vpc_cidr" {
  description = "Dedicated /16 range distinct from the Windows AD lab."
  type        = string
  default     = "10.88.0.0/16"

  validation {
    condition     = var.vpc_cidr == "10.88.0.0/16"
    error_message = "This exercise uses only 10.88.0.0/16; do not target the AD lab range."
  }
}

variable "subnet_number" {
  description = "Subnet index used to calculate a /24 inside the dedicated VPC."
  type        = number
  default     = 10

  validation {
    condition     = var.subnet_number >= 0 && var.subnet_number <= 255 && floor(var.subnet_number) == var.subnet_number
    error_message = "Use a whole subnet index from 0 through 255."
  }
}
