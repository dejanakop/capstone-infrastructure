# BASE NAME
variable "base_name" {
  type    = string
  default = "dkop-dev"
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
  default = ["109.111.235.230", "82.117.193.213", "178.148.238.37"]
}
variable "target_tags" {
  type    = list(string)
  default = ["dkop-dev"]
}

# DATABASE
variable "psc_address" {
  type    = string
  default = "10.20.0.5"
}