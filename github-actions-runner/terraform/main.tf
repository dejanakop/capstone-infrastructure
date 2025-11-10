terraform {
  required_version = ">= 1.13.4"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "7.0.0"
    }
  }
  backend "gcs" {
    bucket = "dkop-capstone-github-runner-tf-backend"
  }
}

provider "google" {
  project = var.project
  region  = var.region
  zone    = var.zone
}

resource "google_project_service" "compute_api" {
  project            = var.project
  service            = "compute.googleapis.com"
  disable_on_destroy = false
}

resource "google_compute_network" "runner_vpc" {
  name                    = "${var.base_name}-vpc"
  auto_create_subnetworks = var.auto_create_subnetworks
  depends_on              = [google_project_service.compute_api]
}

resource "google_compute_subnetwork" "runner_subnet" {
  name          = "${var.base_name}-subnet"
  network       = google_compute_network.runner_vpc.id
  ip_cidr_range = var.ip_cidr_range
}

resource "google_compute_firewall" "runner_firewall" {
  name    = "${var.base_name}-firewall"
  network = google_compute_network.runner_vpc.id
  allow {
    protocol = var.protocol
    ports    = var.ports
  }
  source_ranges = var.source_ranges
  target_tags   = var.target_tags
}

resource "google_compute_instance" "runner_vm" {

  name         = "${var.base_name}-vm"
  machine_type = var.runner_machine_type

  boot_disk {
    initialize_params {
      image = var.runner_image
    }
  }

  network_interface {
    network    = google_compute_network.runner_vpc.id
    subnetwork = google_compute_subnetwork.runner_subnet.id
    access_config {

    }
  }

  tags = var.target_tags

}
