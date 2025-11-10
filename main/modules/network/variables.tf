# VPC
variable "vpc_name" { type = string }
variable "auto_create_subnetworks" { type = bool }

# SUBNET
variable "subnet_name" { type = string }
variable "ip_cidr_range" { type = string }

# FIREWALL
variable "firewall_name" { type = string }
variable "protocol" { type = string }
variable "ports" { type = list(string) }
variable "source_ranges" { type = list(string) }
variable "target_tags" { type = list(string) }