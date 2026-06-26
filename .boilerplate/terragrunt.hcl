locals {
  local_vars  = yamldecode(file("./inputs.yaml"))
  spoke_vars  = yamldecode(file(find_in_parent_folders("spoke-inputs.yaml")))
  region_vars = yamldecode(file(find_in_parent_folders("region-inputs.yaml")))
  env_vars    = yamldecode(file(find_in_parent_folders("env-inputs.yaml")))
  global_vars = yamldecode(file(find_in_parent_folders("global-inputs.yaml")))

  local_tags  = jsondecode(file("./local-tags.json"))
  spoke_tags  = jsondecode(file(find_in_parent_folders("spoke-tags.json")))
  region_tags = jsondecode(file(find_in_parent_folders("region-tags.json")))
  env_tags    = jsondecode(file(find_in_parent_folders("env-tags.json")))
  global_tags = jsondecode(file(find_in_parent_folders("global-tags.json")))

  tags = merge(
    local.global_tags,
    local.env_tags,
    local.region_tags,
    local.spoke_tags,
    local.local_tags
  )
}

include "root" {
  path = find_in_parent_folders("{{ .RootFileName }}")
}
{{ if .vpc_dependency_enabled }}
dependency "vpc" {
  config_path = "{{ .vpc_dependency_path }}"
  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs_allowed_terraform_commands = ["validate", "destroy"]
  mock_outputs = {
    nat_address = tolist([
      "2.2.2.2",
    ])
    intra_subnets = [
      "subnet-01234567890123456",
      "subnet-01234567890123457",
      "subnet-01234567890123458",
    ]
    intra_route_table_ids = [
      "rtb-1234567890",
      "rtb-1234567891",
      "rtb-1234567892",
    ]
    vpc_id = "vpc-12345678901234"
    cloudwatch_log_group = {
      arn  = "arn:aws:logs:us-east-1:123456789012:log-group:network/hub/hub-000/vpc-12345678901234"
      name = "network/hub/hub-000/vpc-12345678901234"
    }
    vpc_cidr_block = "1.0.0.0/8"
  }
}
{{ end }}
{{ if .nfw_dependency_enabled }}
dependency "nfw" {
  config_path = "{{ .nfw_dependency_path }}"
  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs_allowed_terraform_commands = ["validate", "destroy"]
  mock_outputs = {
    firewall_arn = "arn:aws:network-firewall:us-east-1:123456789012:firewall/fw-12345678901234"
    firewall_status = tolist([
      {
        "sync_states" = toset([
          {
            "attachment" = tolist([
              {
                "endpoint_id" = "vpce-12345678901234567"
                "subnet_id"   = "subnet-01234567890123456"
              },
              {
                "endpoint_id" = "vpce-12345678901234568"
                "subnet_id"   = "subnet-01234567890123457"
              },
              {
                "endpoint_id" = "vpce-12345678901234569"
                "subnet_id"   = "subnet-01234567890123458"
              },
            ])
          }
        ])
      }
    ])
  }
}
{{ end}}
terraform {
  source = "{{ .sourceUrl }}"
}

inputs = {
  is_hub     = {{ .is_hub }}
  org        = local.env_vars.org
  spoke_def  = local.spoke_vars.spoke
  {{- range .requiredVariables }}
  {{- if ne .Name "org" }}
  {{ .Name }} = local.local_vars.{{ .Name }}
  {{- end }}
  {{- end }}
  {{- range .optionalVariables }}
  {{- if not (eq .Name "extra_tags" "is_hub" "spoke_def" "org") }}
  {{- if and $.vpc_dependency_enabled (eq .Name "endpoint_subnet_ids") }}
  {{- if eq $.vpc_dependency_subnets "both" }}
  {{ .Name }} = concat(dependency.vpc.outputs.private_subnets, dependency.vpc.outputs.database_subnets)
  {{- else if eq $.vpc_dependency_subnets "none" }}
  {{ .Name }} = try(local.local_vars.{{ .Name }}, [])
  {{- else }}
  {{ .Name }} = dependency.vpc.outputs.{{ $.vpc_dependency_subnets }}_subnets
  {{- end }}
  {{- else if and $.nfw_dependency_enabled (eq .Name "nfw_states_list") }}
  {{ .Name }} = dependency.nfw.outputs.firewall_status[0].sync_states
  {{- else }}
  {{ .Name }} = try(local.local_vars.{{ .Name }}, {{ .DefaultValue }})
  {{- end }}
  {{- end }}
  {{- end }}
  extra_tags = local.tags
}