##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

variable "endpoint_subnet_ids" {
  type    = list(string)
  default = []
}

variable "endpoint_destination_cidr" {
  type    = string
  default = "0.0.0.0/0"
}

variable "nfw_states_list" {
  type    = any
  default = []
}