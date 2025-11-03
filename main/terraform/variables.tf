# BASE NAME
variable "base_name" { type = string }

# TERRAFORM
variable "project" { type = string }
variable "region" { type = string }
variable "zone" { type = string }

# NETWORK
variable "auto_create_subnetworks" { type = bool }
variable "ip_cidr_range" { type = string }