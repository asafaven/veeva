resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress-controller"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "nginx-ingress-controller"
  set {
    name  = "deletion_protection"
    value = "false"
  }
  depends_on = [
    google_container_cluster.gke-cluster
  ]
}

resource "helm_release" "external_dns" {
  name       = "external-dns"

  repository = "https://kubernetes-sigs.github.io/external-dns"
  chart      = "external-dns"
  set {
    name  = "service.type"
    value = "ClusterIP"
  }
  depends_on = [
    google_container_cluster.gke-cluster
  ]
}