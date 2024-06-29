##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

data "aws_subnet" "endpoint_subnets" {
  for_each = toset(var.endpoint_subnet_ids)
  id       = each.value
}

data "aws_route_table" "endpoint_route_table" {
  for_each  = toset(var.endpoint_subnet_ids)
  subnet_id = data.aws_subnet.endpoint_subnets[each.key].id
}

resource "aws_route" "endpoint_route" {
  for_each = merge([
    for ids in var.endpoint_subnet_ids : {
      for state in var.nfw_states_list : (ids) => {
        route_table_id   = data.aws_route_table.endpoint_route_table[ids].id
        destination_cidr = var.endpoint_destination_cidr
        vpc_endpoint_id  = state.attachment[0].endpoint_id
      } if data.aws_subnet.endpoint_subnets[ids].availability_zone == state.availability_zone
    }
  ]...)
  route_table_id         = each.value.route_table_id
  destination_cidr_block = each.value.destination_cidr
  vpc_endpoint_id        = each.value.vpc_endpoint_id
}
