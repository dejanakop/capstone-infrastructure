# CLUSTER
variable "cluster_name" { type = string }
variable "remove_default_node_pool" { type = bool }
variable "initial_node_count" { type = number }
variable "vpc_id" { type = string }
variable "subnet_id" { type = string }
variable "location" { type = string }
variable "node_pool_name" { type = string }
variable "node_count" { type = number }
variable "node_machine_type" { type = string }
variable "disk_type" { type = string }
variable "disk_size_gb" { type = number }