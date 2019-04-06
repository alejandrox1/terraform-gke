terraform {
  required_version = ">= 0.11.0"
}

provider "google" {
  credentials = "${file("./creds/serviceaccount.json")}"
  project     = "k8s-istio-218403"
  region      = "us-east1"
}

data "google_container_engine_versions" "useast1" {
  version_prefix = "1.12."
  location       = "us-east1-b"
}

resource "google_container_cluster" "cluster" {
  name               = "terraform-cluster"
  location           = "us-east1-b"
  min_master_version = "${data.google_container_engine_versions.useast1.latest_master_version}"
  node_version       = "${data.google_container_engine_versions.useast1.latest_node_version}"

  remove_default_node_pool = true
  initial_node_count       = 1
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name               = "my-node-pool"
  location           = "us-east1-b"
  cluster            = "${google_container_cluster.cluster.name}"
  initial_node_count = 3

  autoscaling {
    min_node_count = 1
    max_node_count = 8
  }

  node_config {
    preemptible  = true
    machine_type = "n1-standard-1"

    metadata {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}
