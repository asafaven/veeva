# VPC
resource "google_compute_network" "vpc" {
  name                    = "${var.project_id}-veeva-vpc"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "vpc-subnet" {
  name          = "${var.project_id}-subnet-vpc"
  ip_cidr_range = "10.100.0.0/24"
  region        = var.region
  network       = google_compute_network.vpc.id
  secondary_ip_range {
    range_name    = "subnet-secondary-1"
    ip_cidr_range = "10.200.1.0/24"
  }
  secondary_ip_range {
    range_name    = "subnet-secondary-2"
    ip_cidr_range = "10.200.2.0/24"
  }
}
