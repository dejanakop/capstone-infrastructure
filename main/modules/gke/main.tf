resource "google_container_cluster" "cluster" {
  name                     = var.cluster_name
  remove_default_node_pool = var.remove_default_node_pool
  initial_node_count       = var.initial_node_count
  network                  = var.vpc_id
  subnetwork               = var.subnet_id
  location                 = var.location
  deletion_protection      = false
  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = true
  }
  control_plane_endpoints_config {
    dns_endpoint_config {
      allow_external_traffic = true
    }
    ip_endpoints_config {
      enabled = false
    }
  }
}

resource "google_container_node_pool" "nodes" {
  name       = var.node_pool_name
  cluster    = google_container_cluster.cluster.id
  location   = var.location
  node_count = var.node_count
  node_config {
    machine_type = var.node_machine_type
    disk_type    = var.disk_type
    disk_size_gb = var.disk_size_gb
    tags         = var.tags
    metadata = {
      enable_private_nodes = true
    }
  }
  management {
    auto_repair  = var.auto_repair
    auto_upgrade = var.auto_upgrade
  }
  autoscaling {
    min_node_count = var.min_node_count
    max_node_count = var.max_node_count
  }
}
