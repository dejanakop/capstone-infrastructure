terraform {
  required_version = ">= 1.13.4"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "7.0.0"
    }
  }
  backend "gcs" {
    bucket = "dkop-capstone-main-tf-backend"
  }
}

provider "google" {
  project = var.project
  region  = var.region
  zone    = var.zone
}

resource "google_project_service" "project_apis" {
  for_each           = toset(var.services)
  service            = each.key
  disable_on_destroy = false
}

module "network" {
  source                  = "../../modules/network"
  vpc_name                = "${var.base_name}-vpc"
  auto_create_subnetworks = var.auto_create_subnetworks
  subnet_name             = "${var.base_name}-subnet"
  ip_cidr_range           = var.ip_cidr_range
  firewall_name           = "${var.base_name}-firewall"
  protocol                = var.protocol
  ports                   = var.ports
  source_ranges           = var.source_ranges
  target_tags             = var.target_tags
}

module "gke" {
  source                   = "../../modules/gke"
  cluster_name             = "${var.base_name}-cluster"
  remove_default_node_pool = var.remove_default_node_pool
  initial_node_count       = var.initial_node_count
  vpc_id                   = module.network.vpc_id
  subnet_id                = module.network.subnet_id
  location                 = var.zone
  master_ipv4_cidr_block   = var.master_ipv4_cidr_block
  runner_ip_cidr_range     = var.runner_ip_cidr_range
  node_pool_name           = "${var.base_name}-node-pool"
  node_count               = var.node_count
  node_machine_type        = var.node_machine_type
  disk_type                = var.disk_type
  disk_size_gb             = var.disk_size_gb
  min_node_count           = var.min_node_count
  max_node_count           = var.max_node_count
  auto_repair              = var.auto_repair
  auto_upgrade             = var.auto_upgrade
  tags                     = var.target_tags
}

######################## VPC PEERING ########################

data "google_compute_network" "runner_vpc" {
  name = "github-actions-runner-dkop-vpc"
}

resource "google_compute_network_peering" "runner_to_gke" {
  name         = "peering-runner-to-gke"
  network      = data.google_compute_network.runner_vpc.id
  peer_network = module.network.vpc_id

  export_custom_routes = true
  import_custom_routes = true
}

resource "google_compute_network_peering" "gke_to_runner" {
  name         = "peering-gke-to-runner"
  network      = module.network.vpc_id
  peer_network = data.google_compute_network.runner_vpc.id

  export_custom_routes = true
  import_custom_routes = true
}