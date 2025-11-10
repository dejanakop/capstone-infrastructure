resource "google_sql_database_instance" "petclinic_db_instance" {
  name             = var.db_instance_name
  database_version = var.db_instance_version
  settings {
    tier = var.db_instance_tier
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