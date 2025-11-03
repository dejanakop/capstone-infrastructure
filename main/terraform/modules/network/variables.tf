# VPC
variable "vpc_name" { type = string }
variable "auto_create_subnetworks" { type = bool }

# SUBNET
variable "subnet_name" { type = string }
variable "ip_cidr_range" { type = string }