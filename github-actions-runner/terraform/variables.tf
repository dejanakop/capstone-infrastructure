# BASE NAME
variable "base_name" { type = string }

# TERRAFORM & PROVIDER
variable "project" { type = string }
variable "region" { type = string }
variable "zone" { type = string }
variable "owner" { type = string }

# SERVICES
variable "services" { type = list(string) }

# NETWORK
variable "auto_create_subnetworks" { type = bool }
variable "ip_cidr_range" { type = string }
variable "protocol" { type = string }
variable "ingress_ports" { type = list(string) }
variable "egress_ports" { type = list(string) }
variable "source_ranges" { type = list(string) }
variable "target_tags" { type = list(string) }

# VM
variable "runner_machine_type" { type = string }
variable "runner_image" { type = string }
variable "runner_disk_size" { type = number }
variable "github_pat" {
  type      = string
  sensitive = true
}