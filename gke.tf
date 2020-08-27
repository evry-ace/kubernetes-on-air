resource "google_project_service" "stackdriver" {
  service            = "stackdriver.googleapis.com"
  disable_on_destroy = false
}

resource "google_container_cluster" "apps" {
  provider = google-beta

  name     = "apps"
  location = var.google_zone

  # Configuration options for the Release channel feature, which provide more
  # control over automatic upgrades of your GKE clusters. When updating this
  # field, GKE imposes specific version requirements.
  release_channel {
    channel = "REGULAR"
  }

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }

  # The maintenance policy to use for the cluster.
  maintenance_policy {
    daily_maintenance_window {
      start_time = "03:00"
    }
  }


  # Workload Identity allows Kubernetes service accounts to act as a
  # user-managed Google IAM Service Account.
  workload_identity_config {
    identity_namespace = "${var.google_project}.svc.id.goog"
  }

  # The configuration for addons supported by GKE
  addons_config {
    config_connector_config {
      enabled = true
    }
  }
}

resource "google_container_node_pool" "apps" {
  name               = "preemptible"
  location           = var.google_zone
  cluster            = google_container_cluster.apps.name
  initial_node_count = 1

  autoscaling {
    min_node_count = 0
    max_node_count = 50
  }

  node_config {
    preemptible  = true
    machine_type = "e2-standard-2"

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/trace.append",
    ]
  }
}
