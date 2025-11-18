resource "google_sql_database_instance" "petclinic_db_instance" {
  name             = var.db_instance_name
  database_version = var.db_instance_version
  settings {
    tier = var.db_instance_tier
    ip_configuration {
      psc_config {
        psc_enabled               = true
        allowed_consumer_projects = var.allowed_consumer_projects
      }
    }
  }
  deletion_protection = false
}

resource "google_sql_database" "petclinic_db" {
  name     = var.db_name
  instance = google_sql_database_instance.petclinic_db_instance.id
}

resource "google_sql_user" "user" {
  name     = var.db_username
  instance = google_sql_database_instance.petclinic_db_instance.id
  password = var.db_user_password
}

# PSC
resource "google_compute_address" "psc_address" {
  name         = "${var.db_instance_name}-psc-address"
  address_type = "INTERNAL"
  subnetwork   = var.db_subnet
  address      = var.psc_address
}

resource "google_compute_forwarding_rule" "psc_forwarding_rule" {
  name                    = "${var.db_instance_name}-psc-forwarding-rule"
  network                 = var.db_network
  ip_address              = google_compute_address.psc_address.id
  load_balancing_scheme   = ""
  target                  = google_sql_database_instance.petclinic_db_instance.psc_service_attachment_link
  allow_psc_global_access = true
}