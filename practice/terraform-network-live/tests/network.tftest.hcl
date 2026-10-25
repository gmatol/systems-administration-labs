mock_provider "aws" {}

variables {
  expected_account_id = "111122223333"
}

run "baseline" {
  command = plan

  assert {
    condition     = aws_vpc.practice.cidr_block == "10.88.0.0/16" && aws_subnet.practice.cidr_block == "10.88.10.0/24"
    error_message = "Use only the separate Terraform network range."
  }

  assert {
    condition     = aws_subnet.practice.map_public_ip_on_launch == false
    error_message = "Public IP auto-assignment must remain disabled."
  }
}

run "tag_update" {
  command = plan

  variables {
    environment = "interview-practice"
  }

  assert {
    condition     = aws_vpc.practice.tags["Environment"] == "interview-practice"
    error_message = "The tag input must reach the VPC configuration."
  }
}

run "reject_ad_range" {
  command = plan

  variables {
    vpc_cidr = "10.77.0.0/16"
  }

  expect_failures = [var.vpc_cidr]
}
