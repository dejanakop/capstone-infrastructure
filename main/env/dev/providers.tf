terraform {
  required_version = ">= 1.13.4"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "7.0.0"
    }
  }
}

provider "google" {
  project = var.project
  region  = var.region
  zone    = var.zone
}