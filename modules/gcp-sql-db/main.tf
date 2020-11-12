############################
# SQL Database
############################

resource "google_sql_database_instance" "master" {
  provider = google-beta

  project = var.project

  name = "${var.prefix}-${var.region}-${var.name}"

  region              = var.region
  database_version    = var.database_version
  root_password       = var.root_password
  deletion_protection = var.deletion_protection

  master_instance_name = var.availability_type == "REGIONAL" ? "${var.prefix}-${var.region}-${var.name}-master" : null

  settings {
    tier              = var.tier
    activation_policy = "ON_DEMAND"
    disk_autoresize   = true
    disk_type         = "PD_SSD"
    pricing_plan      = "PER_USE"

    availability_type = var.availability_type

    ip_configuration {
      ipv4_enabled    = false
      private_network = var.private_network_id
      require_ssl     = true
    }

    backup_configuration {
      binary_log_enabled = var.availability_type == "REGIONAL" ? true : false
      enabled            = var.backup_enabled
    }

    maintenance_window {
      update_track = "stable"
    }

    user_labels = merge(
      var.labels,
      {
        name   = "${var.prefix}-${var.region}-${var.name}",
        prefix = var.prefix,
      }
    )

  }
}

resource "google_sql_ssl_cert" "client_cert" {
  common_name = "client"
  instance    = google_sql_database_instance.master.name
}
