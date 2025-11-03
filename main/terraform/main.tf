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
  source = "./modules/network"
  vpc_name = "${var.base_name}-vpc"
  auto_create_subnetworks = var.auto_create_subnetworks
  subnet_name = "${var.base_name}-subnet"
  ip_cidr_range = var.ip_cidr_range
}