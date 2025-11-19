variable "db_instance_name" { type = string }
variable "db_instance_version" { type = string }
variable "db_instance_tier" { type = string }
variable "db_name" { type = string }

variable "allowed_consumer_projects" { type = list(string) }
variable "db_subnet" { type = string }
variable "db_network" { type = string }
variable "psc_address" { type = string }
variable "host" { type = string }