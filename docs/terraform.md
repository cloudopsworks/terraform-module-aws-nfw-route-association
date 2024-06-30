## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_tags"></a> [tags](#module\_tags) | cloudopsworks/tags/local | 1.0.9 |

## Resources

| Name | Type |
|------|------|
| [aws_route.endpoint_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_route_table.endpoint_route_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route_table) | data source |
| [aws_subnet.endpoint_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_endpoint_destination_cidr"></a> [endpoint\_destination\_cidr](#input\_endpoint\_destination\_cidr) | n/a | `string` | `"0.0.0.0/0"` | no |
| <a name="input_endpoint_subnet_ids"></a> [endpoint\_subnet\_ids](#input\_endpoint\_subnet\_ids) | n/a | `list(string)` | `[]` | no |
| <a name="input_extra_tags"></a> [extra\_tags](#input\_extra\_tags) | n/a | `map(string)` | `{}` | no |
| <a name="input_is_hub"></a> [is\_hub](#input\_is\_hub) | Establish this is a HUB or spoke configuration | `bool` | `false` | no |
| <a name="input_nfw_states_list"></a> [nfw\_states\_list](#input\_nfw\_states\_list) | n/a | `any` | `[]` | no |
| <a name="input_org"></a> [org](#input\_org) | n/a | <pre>object({<br>    organization_name = string<br>    organization_unit = string<br>    environment_type  = string<br>    environment_name  = string<br>  })</pre> | n/a | yes |
| <a name="input_spoke_def"></a> [spoke\_def](#input\_spoke\_def) | n/a | `string` | `"001"` | no |

## Outputs

No outputs.
