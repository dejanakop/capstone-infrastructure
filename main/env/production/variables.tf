# BASE NAME
variable "base_name" {
  type    = string
  default = "dkop-production"
}

# TERRAFORM
variable "project" {
  type      = string
  sensitive = true
}
variable "region" {
  type    = string
  default = "europe-west1"
}
variable "zone" {
  type    = string
  default = "europe-west1-b"
}

# SERVICES
variable "services" {
  type = list(string)
  default = [
    "compute.googleapis.com",
    "monitoring.googleapis.com",
    "logging.googleapis.com",
    "container.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "autoscaling.googleapis.com",
    "serviceusage.googleapis.com",
    "iap.googleapis.com",
    "dns.googleapis.com",
    "networkconnectivity.googleapis.com",
  ]
}

# NETWORK
variable "auto_create_subnetworks" {
  type    = bool
  default = false
}
variable "ip_cidr_range" {
  type    = string
  default = "10.20.0.0/24"
}
# FIREWALL
variable "protocol" {
  type    = string
  default = "tcp"
}
variable "ports" {
  type    = list(string)
  default = ["80", "443", "22"]
}
variable "source_ranges" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}
variable "target_tags" {
  type    = list(string)
  default = ["dkop-production"]
}

# CLUSTER
variable "remove_default_node_pool" {
  type    = bool
  default = true
}
variable "initial_node_count" {
  type    = number
  default = 1
}
variable "node_count" {
  type    = number
  default = 1
}
variable "node_machine_type" {
  type    = string
  default = "e2-standard-2"
}
variable "disk_type" {
  type    = string
  default = "pd-ssd"
}
variable "disk_size_gb" {
  type    = number
  default = 20
}
variable "min_node_count" {
  type    = number
  default = 1
}
variable "max_node_count" {
  type    = number
  default = 5
}
variable "auto_repair" {
  type    = bool
  default = true
}
variable "auto_upgrade" {
  type    = bool
  default = true
}

# DATABASE
variable "db_instance_version" {
  type    = string
  default = "MYSQL_8_0"
}
variable "db_instance_tier" {
  type    = string
  default = "db-f1-micro"
}
variable "psc_address" {
  type    = string
  default = "10.20.0.5"
}
variable "host" {
  type    = string
  default = "%"
}