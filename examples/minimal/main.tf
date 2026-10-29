terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0, < 7.0"
    }
  }
}

locals {
  context = {
    organization = "olensys"
    environment  = "test"
    application  = "subnet"
    owner        = "platform"
    cost_center  = "eng"
  }
}

module "naming" {
  source = "git::https://github.com/Olensys/terraform-null-naming.git?ref=v1.0.1"

  context = local.context
}

data "aws_availability_zones" "available" {
  state = "available"
}

# Prerequisites the module does not create. Both carry the olensys-test- name so the sweeper finds them.
#trivy:ignore:AVD-AWS-0178 test fixture; flow logs add nothing to a VPC that exists for one apply
resource "aws_vpc" "this" {
  cidr_block = "10.90.0.0/16"

  tags = merge(module.naming.tags, { Name = module.naming.name })
}

resource "aws_route_table" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(module.naming.tags, { Name = module.naming.name })
}

module "this" {
  source = "../../"

  name    = module.naming.name
  context = local.context

  vpc_id            = aws_vpc.this.id
  cidr_block        = "10.90.1.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]
  route_table_id    = aws_route_table.this.id

  tags = module.naming.tags
}

output "id" {
  description = "ID of the subnet."
  value       = module.this.id
}

output "route_table_association_id" {
  description = "ID of the route table association."
  value       = module.this.route_table_association_id
}
