# terraform-aws-subnet

Subnet in an existing VPC with an optional route table association

## Opinions

- One subnet per module instance; call the module with `for_each` for several subnets.
- `map_public_ip_on_launch` is `false` unless set, so instances do not get a public IP by default.
- Without `route_table_id` no association is created and the subnet uses the VPC main route table.
- The subnet gets a `Name` tag equal to `name`.
- The VPC, route tables and gateways are not created here; use `terraform-aws-vpc` for those.

## Usage

```hcl
module "naming" {
  source  = "git::https://github.com/Olensys/terraform-null-naming.git?ref=v1.0.1"
  context = var.context
}

module "subnet" {
  source  = "git::https://github.com/Olensys/terraform-aws-subnet.git?ref=v0.1.0"
  name    = "app-private-a"
  context = var.context

  vpc_id            = module.vpc.id
  cidr_block        = "10.0.32.0/24"
  availability_zone = "us-west-2a"
  route_table_id    = module.vpc.private_route_table_ids[0]

  tags = module.naming.tags
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.0, < 7.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 6.0, < 7.0 |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [aws_route_table_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_subnet.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_availability_zone"></a> [availability\_zone](#input\_availability\_zone) | Availability zone of the subnet, for example us-west-2a. | `string` | n/a | yes |
| <a name="input_cidr_block"></a> [cidr\_block](#input\_cidr\_block) | IPv4 CIDR block of the subnet. Must fall inside the VPC CIDR. | `string` | n/a | yes |
| <a name="input_context"></a> [context](#input\_context) | Deployment context used for naming, tagging and environment-dependent defaults. | <pre>object({<br/>    organization = string<br/>    environment  = string<br/>    application  = string<br/>    component    = optional(string)<br/>    owner        = string<br/>    cost_center  = string<br/>    extra_tags   = optional(map(string), {})<br/>  })</pre> | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Resource name. Lowercase letters, digits and hyphens. | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of the VPC the subnet belongs to. | `string` | n/a | yes |
| <a name="input_create"></a> [create](#input\_create) | Whether to create any resources. Set false to create nothing. | `bool` | `true` | no |
| <a name="input_map_public_ip_on_launch"></a> [map\_public\_ip\_on\_launch](#input\_map\_public\_ip\_on\_launch) | Whether instances launched in the subnet get a public IP by default. Defaults to false; request a public IP explicitly where one is needed. | `bool` | `false` | no |
| <a name="input_route_table_id"></a> [route\_table\_id](#input\_route\_table\_id) | Route table to associate with the subnet. Null creates no association, so the subnet uses the VPC main route table. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags merged onto every taggable resource, applied last. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_arn"></a> [arn](#output\_arn) | ARN of the subnet. Null when create is false. |
| <a name="output_availability_zone"></a> [availability\_zone](#output\_availability\_zone) | Availability zone of the subnet. Null when create is false. |
| <a name="output_cidr_block"></a> [cidr\_block](#output\_cidr\_block) | IPv4 CIDR block of the subnet. Null when create is false. |
| <a name="output_id"></a> [id](#output\_id) | ID of the subnet. Null when create is false. |
| <a name="output_name"></a> [name](#output\_name) | Name of the subnet (its Name tag). Null when create is false. |
| <a name="output_route_table_association_id"></a> [route\_table\_association\_id](#output\_route\_table\_association\_id) | ID of the route table association. Null when create is false or no route table is given. |
| <a name="output_tags"></a> [tags](#output\_tags) | Tags applied to the subnet, with context.extra\_tags merged in. Null when create is false. |
<!-- END_TF_DOCS -->
