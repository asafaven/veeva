provider "google" {
  project = var.project_id
  region  = var.region
}

provider "kubernetes" {
  host = var.kube_host
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}