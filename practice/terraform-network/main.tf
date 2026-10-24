locals {
  common_tags = {
    Project     = var.project_name
    Environment = "practice-only"
    ManagedBy   = "Terraform"
  }
}

resource "aws_vpc" "practice" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = merge(local.common_tags, { Name = var.project_name })

  lifecycle {
    precondition {
      condition     = can(regex("/16$", var.vpc_cidr))
      error_message = "This beginner exercise requires a /16 VPC so eight additional bits produce /24 subnets."
    }
  }
}

resource "aws_subnet" "practice" {
  vpc_id                  = aws_vpc.practice.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, var.subnet_number)
  map_public_ip_on_launch = false
  tags                    = merge(local.common_tags, { Name = "${var.project_name}-subnet" })
}

resource "aws_security_group" "practice" {
  name_prefix = "${var.project_name}-"
  description = "Practice only: group members can communicate; no public inbound access"
  vpc_id      = aws_vpc.practice.id
  tags        = merge(local.common_tags, { Name = "${var.project_name}-sg" })
}

# Separate rule resources avoid a self-reference cycle inside the group resource.
# Do not mix these with inline ingress/egress rules for this same group.
resource "aws_vpc_security_group_ingress_rule" "internal" {
  security_group_id            = aws_security_group.practice.id
  referenced_security_group_id = aws_security_group.practice.id
  ip_protocol                  = "-1"
  description                  = "Only members of this security group"
}

resource "aws_vpc_security_group_egress_rule" "outbound" {
  security_group_id = aws_security_group.practice.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  description       = "Outbound traffic concept from the existing lab"
}
