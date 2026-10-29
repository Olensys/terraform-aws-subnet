mock_provider "aws" {
  mock_resource "aws_subnet" {
    defaults = {
      id  = "subnet-0123456789abcdef0"
      arn = "arn:aws:ec2:eu-west-1:123456789012:subnet/subnet-0123456789abcdef0"
    }
  }
}

variables {
  context = {
    organization = "olensys"
    environment  = "test"
    application  = "example"
    owner        = "platform"
    cost_center  = "eng"
  }
  name              = "example"
  vpc_id            = "vpc-0123456789abcdef0"
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-west-1a"
}

run "test_create_false_plans_nothing" {
  command = plan

  variables {
    create         = false
    route_table_id = "rtb-0123456789abcdef0"
  }

  assert {
    condition = alltrue([
      output.id == null, output.name == null, output.arn == null, output.availability_zone == null,
      output.cidr_block == null, output.route_table_association_id == null, output.tags == null,
    ])
    error_message = "All outputs must be null when create is false."
  }

  assert {
    condition     = length(aws_subnet.this) == 0 && length(aws_route_table_association.this) == 0
    error_message = "No resources may be planned when create is false."
  }
}

run "test_subnet_defaults" {
  command = plan

  assert {
    condition     = aws_subnet.this[0].map_public_ip_on_launch == false && aws_subnet.this[0].cidr_block == "10.0.1.0/24" && aws_subnet.this[0].availability_zone == "eu-west-1a"
    error_message = "The subnet must not assign public IPs by default and must use the given CIDR and zone."
  }

  assert {
    condition     = length(aws_route_table_association.this) == 0
    error_message = "No route table association without route_table_id."
  }
}

run "test_route_table_association" {
  command = plan

  variables {
    route_table_id = "rtb-0123456789abcdef0"
  }

  assert {
    condition     = aws_route_table_association.this[0].route_table_id == "rtb-0123456789abcdef0"
    error_message = "The subnet must be associated with the given route table."
  }
}

run "test_public_ip_opt_in" {
  command = plan

  variables {
    map_public_ip_on_launch = true
  }

  assert {
    condition     = aws_subnet.this[0].map_public_ip_on_launch == true
    error_message = "map_public_ip_on_launch must be honoured."
  }
}

run "test_cidr_validation" {
  command = plan

  variables {
    cidr_block = "not-a-cidr"
  }

  expect_failures = [var.cidr_block]
}

run "test_name_rejects_uppercase" {
  command = plan

  variables {
    name = "Bad-Name"
  }

  expect_failures = [var.name]
}

run "test_tags_contract" {
  command = plan

  variables {
    context = {
      organization = "olensys"
      environment  = "test"
      application  = "example"
      owner        = "platform"
      cost_center  = "eng"
      extra_tags   = { Owner = "y", Team = "z" }
    }
    tags = { Owner = "x" }
  }

  assert {
    condition     = output.tags.Owner == "x" && output.tags.Team == "z" && output.tags.Name == "example"
    error_message = "var.tags must win over context.extra_tags, and Name must be set."
  }
}
