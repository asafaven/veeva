resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress-controller"
  repository = "https://kubernetes.github.io/ingress-nginx"
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

resource "kubernetes_namespace" "web" {
  metadata {
    name = "web"
  }
}
resource "helm_release" "web" {
  name       = "web"
  namespace  = "web"
  chart      = "../helm/veeva-nginx"
  depends_on = [
    google_container_node_pool.nodepool,
    helm_release.nginx_ingress,
    kubernetes_namespace.web
  ]
}