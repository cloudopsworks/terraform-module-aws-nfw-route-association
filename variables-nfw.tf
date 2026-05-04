##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

variable "endpoint_subnet_ids" {
  description = "List of subnet IDs whose associated route tables should receive a route that targets the AWS Network Firewall VPC endpoint in the same Availability Zone."
  type        = list(string)
  default     = []
}

variable "endpoint_destination_cidr" {
  description = "Destination CIDR block to route through the AWS Network Firewall endpoints."
  type        = string
  default     = "0.0.0.0/0"
}

variable "nfw_states_list" {
  description = "AWS Network Firewall sync states keyed by availability zone, typically sourced from firewall_status[0].sync_states."
  type        = any
  default     = []
}
