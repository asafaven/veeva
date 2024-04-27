resource "google_service_account" "gke-cluster-sa" {
  account_id   = "gke-cluster-se"
  display_name = "Service Account"
}

resource "google_project_iam_member" "gke-cluster-sa-iam-member" {
  project = var.project_id
  # role    = "roles/container.defaultNodeServiceAccount"
  role    = "roles/editor"
  member  = google_service_account.gke-cluster-sa.member
}

resource "google_container_cluster" "gke-cluster" {
  name     = var.cluster_name
  location = var.zone
  network = google_compute_network.vpc.id
  subnetwork = google_compute_subnetwork.vpc-subnet.name
  # cluster_ipv4_cidr = google_compute_subnetwork.vpc-subnet.ip_cidr_range
  remove_default_node_pool = true
  initial_node_count       = 1
  deletion_protection = false
  ip_allocation_policy {
    cluster_secondary_range_name  = google_compute_subnetwork.vpc-subnet.secondary_ip_range[0].range_name
    services_secondary_range_name = google_compute_subnetwork.vpc-subnet.secondary_ip_range[1].range_name
  }
}

resource "google_container_node_pool" "nodepool" {
  name       = var.nodepool_name
  location   = var.zone
  cluster    = google_container_cluster.gke-cluster.name
  node_count = 1

  node_config {
    preemptible  = false
    machine_type = "e2-standard-2"
    service_account = google_service_account.gke-cluster-sa.email
  }
}