resource "google_project_service" "allow_compute_service" {
  project = "${var.project_id}"
  service = "compute.googleapis.com"
}