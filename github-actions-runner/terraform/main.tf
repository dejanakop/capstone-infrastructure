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

resource "google_compute_firewall" "runner_firewall_ingress" {
  name    = "${var.base_name}-firewall-ingress"
  network = google_compute_network.runner_vpc.id
  allow {
    protocol = var.protocol
    ports    = var.ports
  }
  source_ranges = var.source_ranges
  target_tags   = var.target_tags
}

resource "google_compute_firewall" "runner_firewall_egress" {
  name      = "${var.base_name}-firewall-egress"
  network   = google_compute_network.runner_vpc.id
  direction = "EGRESS"
  allow {
    protocol = var.protocol
    ports    = ["80", "443"]
  }
  source_ranges = var.source_ranges
  target_tags   = var.target_tags
}

resource "google_compute_router" "nat_router" {
  name    = "nat-router"
  network = google_compute_network.runner_vpc.id
  region  = var.region
}

resource "google_compute_router_nat" "nat" {
  name                               = "nat-config"
  router                             = google_compute_router.nat_router.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
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
  }

  metadata_startup_script = <<-EOF
  #!/bin/bash
  
  # INSTALLING DOCKER
  sudo apt-get update -y
  sudo apt-get install -y curl jq tar unzip apt-transport-https ca-certificates gnupg lsb-release software-properties-common
  curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt-get update -y
  sudo apt-get install -y docker-ce docker-ce-cli containerd.io
  sudo systemctl enable docker
  sudo systemctl start docker
  sudo usermod -aG docker $USER
  
  # Wait for network
  echo "Waiting for network..."
  until ping -c1 github.com &>/dev/null; do
    echo "Network not ready, retrying..."
    sleep 2
  done
  
  cd /opt
  mkdir -p github-runner
  cd github-runner
  
  echo "Downloading GitHub Actions Runner..."
  curl -fsSL -o actions-runner-linux-x64-2.329.0.tar.gz \
    https://github.com/actions/runner/releases/download/v2.329.0/actions-runner-linux-x64-2.329.0.tar.gz
  
  echo "Extracting..."
  tar xzf actions-runner-linux-x64-2.329.0.tar.gz
  
  echo "Installing dependencies..."
  apt-get update -y
  apt-get install -y jq curl tar unzip
  
  GITHUB_PAT="${var.github_pat}"
  
  echo "Requesting registration token..."
  TOKEN_RESULT=$(curl -s -X POST \
    -H "Authorization: token $GITHUB_PAT" \
    https://api.github.com/repos/dejanakop/capstone-infrastructure/actions/runners/registration-token)
  
  TOKEN=$(echo "$TOKEN_RESULT" | jq -r .token)
  
  if [[ "$TOKEN" == "null" || -z "$TOKEN" ]]; then
    echo "Failed to get runner token!"
    echo "$TOKEN_RESULT"
    exit 1
  fi
  
  echo "Runner token acquired: $TOKEN"
  
  echo "Configuring runner..."
  useradd -m runner
  chown -R runner:runner /opt/github-runner
  
  sudo -u runner bash -c "
  cd /opt/github-runner
  ./config.sh \
    --url https://github.com/dejanakop/capstone-infrastructure \
    --token '$TOKEN' \
    --unattended --replace
  "
  
  echo "Setting up service..."
  sudo ./svc.sh install
  sudo ./svc.sh start
  
  echo "===== STARTUP SCRIPT COMPLETE ====="
  EOF

  tags = var.target_tags

}
