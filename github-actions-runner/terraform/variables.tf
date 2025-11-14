# BASE NAME
variable "base_name" { type = string }

# TERRAFORM & PROVIDER
variable "backend_bucket" { type = string }
variable "project" { type = string }
variable "region" { type = string }
variable "zone" { type = string }

# NETWORK
variable "auto_create_subnetworks" { type = bool }
variable "ip_cidr_range" { type = string }
variable "protocol" { type = string }
variable "ports" { type = list(string) }
variable "source_ranges" { type = list(string) }
variable "target_tags" { type = list(string) }

# VM
variable "runner_machine_type" { type = string }
variable "runner_image" { type = string }
variable "github_pat" {
  type      = string
  sensitive = true
}