output "id" {
  description = "ID of the subnet. Null when create is false."
  value       = var.create ? aws_subnet.this[0].id : null
}

output "name" {
  description = "Name of the subnet (its Name tag). Null when create is false."
  value       = var.create ? var.name : null
}

output "arn" {
  description = "ARN of the subnet. Null when create is false."
  value       = var.create ? aws_subnet.this[0].arn : null
}

output "availability_zone" {
  description = "Availability zone of the subnet. Null when create is false."
  value       = var.create ? aws_subnet.this[0].availability_zone : null
}

output "cidr_block" {
  description = "IPv4 CIDR block of the subnet. Null when create is false."
  value       = var.create ? aws_subnet.this[0].cidr_block : null
}

output "route_table_association_id" {
  description = "ID of the route table association. Null when create is false or no route table is given."
  value       = var.create && var.route_table_id != null ? aws_route_table_association.this[0].id : null
}

output "tags" {
  description = "Tags applied to the subnet, with context.extra_tags merged in. Null when create is false."
  value       = var.create ? local.tags : null
}
