resource "google_container_cluster" "cluster" {
  name                     = var.cluster_name
  remove_default_node_pool = var.remove_default_node_pool
  initial_node_count       = var.initial_node_count
  network                  = var.vpc_id
  subnetwork               = var.subnet_id
  location                 = var.location
}