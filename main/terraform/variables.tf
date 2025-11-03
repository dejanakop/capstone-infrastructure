# BASE NAME
variable "base_name" { type = string }

# TERRAFORM
variable "project" { type = string }
variable "region" { type = string }
variable "zone" { type = string }

# NETWORK
variable "auto_create_subnetworks" { type = bool }
variable "ip_cidr_range" { type = string }

# CLUSTER
variable "remove_default_node_pool" { type = bool }
variable "initial_node_count" { type = number }
variable "node_count" { type = number }
variable "node_machine_type" { type = string }
variable "disk_type" { type = string }
variable "disk_size_gb" { type = number }