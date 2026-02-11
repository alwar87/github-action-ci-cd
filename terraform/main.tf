resource "google_container_cluster" "gke" {
  name     = "gav1st-gke"          # Must match GKE_CLUSTER in workflow
  location = "us-central1"         # Must match GKE_REGION in workflow

  remove_default_node_pool = true
  initial_node_count       = 1

  network    = var.network
  subnetwork = var.subnetwork

  addons_config {
    http_load_balancing {
      disabled = false
    }
  }

  monitoring_config {
    managed_prometheus {
      enabled = true
    }
  }

  release_channel {
    channel = "REGULAR"
  }
}

resource "google_container_node_pool" "gke_nodes" {
  name     = "gav1st-node-pool"
  location = "us-central1"                     # Must match cluster location
  cluster  = google_container_cluster.gke.name

  node_count = 2

  node_config {
    machine_type = "e2-medium"

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    labels = {
      env = "dev"
    }
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }
}
