terraform {
  required_version = ">= 1.13.4"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "7.0.0"
    }
  }
  backend "gcs" {
    bucket = "capstone-dev-backend"
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

module "db" {
  source                    = "../../modules/db"
  db_instance_name          = "${var.base_name}-db-instance"
  db_instance_version       = var.db_instance_version
  db_instance_tier          = var.db_instance_tier
  allowed_consumer_projects = [var.project]
  db_subnet                 = module.network.subnet_name
  psc_address               = var.psc_address
  db_network                = module.network.vpc_name
  db_name                   = "${var.base_name}-db"
  db_username               = var.db_username
  db_user_password          = var.db_user_password
  host                      = var.host
}