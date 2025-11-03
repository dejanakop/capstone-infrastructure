# CLUSTER
variable "cluster_name" { type = string }
variable "remove_default_node_pool" { type = bool }
variable "initial_node_count" { type = number }
variable "vpc_id" { type = string }
variable "subnet_id" { type = string }
variable "location" { type = string }