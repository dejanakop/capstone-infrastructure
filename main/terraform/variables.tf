# BASE NAME
variable "base_name" { type = string }

# TERRAFORM
variable "project" { type = string }
variable "region" { type = string }
variable "zone" { type = string }
variable "kubernetes_config_path" { type = string }

# NETWORK
variable "auto_create_subnetworks" { type = bool }
variable "ip_cidr_range" { type = string }
# FIREWALL
variable "protocol" { type = string }
variable "ports" { type = list(string) }
variable "source_ranges" { type = list(string) }
variable "target_tags" { type = list(string) }

# CLUSTER
variable "remove_default_node_pool" { type = bool }
variable "initial_node_count" { type = number }
variable "node_count" { type = number }
variable "node_machine_type" { type = string }
variable "disk_type" { type = string }
variable "disk_size_gb" { type = number }
variable "min_node_count" { type = number }
variable "max_node_count" { type = number }
variable "auto_repair" { type = bool }
variable "auto_upgrade" { type = bool }

# HELM
variable "release_name" { type = string }
variable "repository" { type = string }
variable "chart_name" { type = string }
variable "namespace" { type = string }
variable "values" { type = list(string) }