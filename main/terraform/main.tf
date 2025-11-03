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