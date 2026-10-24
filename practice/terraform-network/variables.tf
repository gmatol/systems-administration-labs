variable "aws_region" {
  description = "Region used to understand provider configuration; mock tests make no AWS calls."
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Practice-only resource tag and security group name prefix."
  type        = string
  default     = "guot-terraform-practice"
}

variable "vpc_cidr" {
  description = "Same network concept as the CloudFormation lab; does not select its existing VPC."
  type        = string
  default     = "10.77.0.0/16"

  validation {
    condition     = can(cidrnetmask(var.vpc_cidr))
    error_message = "vpc_cidr must be a valid IPv4 CIDR, for example 10.77.0.0/16."
  }
}

variable "subnet_number" {
  description = "A /24 subnet index within the practice /16 VPC. 10 yields 10.77.10.0/24."
  type        = number
  default     = 10

  validation {
    condition     = var.subnet_number >= 0 && var.subnet_number <= 255 && floor(var.subnet_number) == var.subnet_number
    error_message = "subnet_number must be a whole number from 0 through 255."
  }
}
