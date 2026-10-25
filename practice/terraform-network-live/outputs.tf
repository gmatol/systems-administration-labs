output "vpc_id" {
  description = "Computed practice VPC ID; a mock value during tests; real after an authorized local deployment."
  value       = aws_vpc.practice.id
}

output "subnet_id" {
  description = "Computed practice subnet ID; a mock value during tests; real after an authorized local deployment."
  value       = aws_subnet.practice.id
}

output "subnet_cidr" {
  description = "Calculated subnet CIDR; known before AWS resource creation."
  value       = aws_subnet.practice.cidr_block
}

output "security_group_id" {
  description = "Computed practice security group ID; a mock value during tests; real after an authorized local deployment."
  value       = aws_security_group.practice.id
}
