terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "7.0.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "1.7"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
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

provider "kubernetes" {
  config_path = var.kubernetes_config_path
}

provider "helm" {
  kubernetes {
    config_path = var.kubernetes_config_path
  }
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
  node_pool_name           = "${var.base_name}-node-pool"
  node_count               = var.node_count
  node_machine_type        = var.node_machine_type
  disk_type                = var.disk_type
  disk_size_gb             = var.disk_size_gb
  min_node_count           = var.min_node_count
  max_node_count           = var.max_node_count
  auto_repair              = var.auto_repair
  auto_upgrade             = var.auto_upgrade
}

module "helm" {
  source       = "./modules/helm"
  release_name = var.release_name
  repository   = var.repository
  chart_name   = var.chart_name
  namespace    = var.namespace
  values       = var.values
}