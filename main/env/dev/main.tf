resource "google_project_service" "project_apis" {
  for_each           = toset(var.services)
  service            = each.key
  disable_on_destroy = false
}

module "network" {
  source        = "git::https://github.com/dejanakop/capstone-terraform-modules.git//network?ref=v1.1.0"
  vpc_name      = "${var.base_name}-vpc"
  subnet_name   = "${var.base_name}-subnet"
  ip_cidr_range = var.ip_cidr_range
  firewall_name = "${var.base_name}-firewall"
  protocol      = var.protocol
  ports         = var.ports
  source_ranges = var.source_ranges
  target_tags   = var.target_tags
}

module "gke" {
  source         = "git::https://github.com/dejanakop/capstone-terraform-modules.git//gke?ref=v1.1.0"
  cluster_name   = "${var.base_name}-cluster"
  vpc_id         = module.network.vpc_id
  subnet_id      = module.network.subnet_id
  location       = var.zone
  node_pool_name = "${var.base_name}-node-pool"
  tags           = var.target_tags
}

module "db" {
  source                    = "git::https://github.com/dejanakop/capstone-terraform-modules.git//db?ref=v1.1.0"
  db_instance_name          = "${var.base_name}-db-instance"
  allowed_consumer_projects = [var.project]
  db_subnet                 = module.network.subnet_name
  psc_address               = var.psc_address
  db_network                = module.network.vpc_name
  db_name                   = "${var.base_name}-db"
}
