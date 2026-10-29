# The subnet is the primary resource and is named `this`.

locals {
  # Merge onto every taggable resource, with var.tags applied last.
  tags = merge({ Name = var.name }, var.context.extra_tags, var.tags)
}

resource "aws_subnet" "this" {
  count = var.create ? 1 : 0

  vpc_id                  = var.vpc_id
  cidr_block              = var.cidr_block
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = local.tags
}

resource "aws_route_table_association" "this" {
  count = var.create && var.route_table_id != null ? 1 : 0

  subnet_id      = aws_subnet.this[0].id
  route_table_id = var.route_table_id
}
