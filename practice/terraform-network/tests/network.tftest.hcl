# Every run explicitly uses plan. Do not replace the mock with a real provider.
mock_provider "aws" {}

run "baseline" {
  command = plan

  assert {
    condition     = aws_subnet.practice.cidr_block == "10.77.10.0/24"
    error_message = "Expected subnet 10.77.10.0/24. Check cidrsubnet and subnet_number."
  }

  assert {
    condition     = aws_subnet.practice.map_public_ip_on_launch == false
    error_message = "The practice subnet must not auto-assign public IPs."
  }

  assert {
    condition     = aws_vpc.practice.enable_dns_support && aws_vpc.practice.enable_dns_hostnames
    error_message = "Both VPC DNS settings must remain enabled."
  }
}

run "alternate_subnet" {
  command = plan

  variables {
    subnet_number = 20
  }

  assert {
    condition     = aws_subnet.practice.cidr_block == "10.77.20.0/24"
    error_message = "Subnet index 20 should yield 10.77.20.0/24."
  }
}

run "reject_invalid_subnet" {
  command = plan

  variables {
    subnet_number = 256
  }

  expect_failures = [var.subnet_number]
}
