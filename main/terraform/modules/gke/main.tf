resource "google_container_cluster" "cluster" {
  name                     = var.cluster_name
  remove_default_node_pool = var.remove_default_node_pool
  initial_node_count       = var.initial_node_count
  network                  = var.vpc_id
  subnetwork               = var.subnet_id
  location                 = var.location
}

resource "google_container_node_pool" "nodes" {
  name       = var.node_pool_name
  cluster    = google_container_cluster.cluster.id
  node_count = var.node_count
  node_config {
    machine_type = var.node_machine_type
  }
}