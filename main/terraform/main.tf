terraform {
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

module "network" {
  source                  = "./modules/network"
  vpc_name                = "${var.base_name}-vpc"
  auto_create_subnetworks = var.auto_create_subnetworks
  subnet_name             = "${var.base_name}-subnet"
  ip_cidr_range           = var.ip_cidr_range
}

module "gke" {
  source                   = "./modules/gke"
  cluster_name             = "${var.base_name}-cluster"
  remove_default_node_pool = var.remove_default_node_pool
  initial_node_count       = var.initial_node_count
  vpc_id                   = module.network.vpc_id
  subnet_id                = module.network.subnet_id
  location                 = var.zone
}