resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress-controller"
#   repository = "https://charts.bitnami.com/bitnami"
  repository = "https://kubernetes.github.io/ingress-nginx"
#   chart      = "nginx-ingress-controller"
  chart = "ingress-nginx"
  set {
    name  = "deletion_protection"
    value = "false"
  }
  set {
    name = "rbac.create"
    value = "true" 
  }
  set {
    name = "controller.service.type"
    value = "LoadBalancer" 
  }
  set {
    name = "controller.service.externalTrafficPolicy"
    value = "Local" 
  }
  set {
    name = "controller.publishService.enabled"
    value = "true" 
  }
  depends_on = [
    google_container_node_pool.nodepool
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
    google_container_node_pool.nodepool
  ]
}