resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "my-node-pool"
  cluster    = google_container_cluster.primary.name
  node_count = 1

  node_config {
    machine_type = "e2-medium"
    tags         = ["gke-node"]  # <--- This matches the firewall rule above!
  }
}

resource "google_compute_firewall" "gke_example" {
  name    = "allow-gke-ssh-http"
  network = "default"  # Or your custom network name

  allow {
    protocol = "tcp"
    ports    = ["22", "80"] # SSH and HTTP
  }

  source_ranges = ["0.0.0.0/0"] # WARNING: Open to world. Lock it down as needed.

  target_tags = ["gke-node"]  # Only nodes with this tag get the rule
}
