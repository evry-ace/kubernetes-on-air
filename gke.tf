resource "google_project_service" "stackdriver" {
  service            = "stackdriver.googleapis.com"
  disable_on_destroy = false
}
resource "google_container_cluster" "apps" {
  name     = "apps"
  location = var.google_zone

  min_master_version = "1.15.9-gke.26"

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
