provider "google" {
  project = var.project_id
  region  = var.region
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}


provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}