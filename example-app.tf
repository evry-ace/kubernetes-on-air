resource "helm_release" "nginx_app" {
  name       = "nginx-app"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "nginx"
  version    = "5.1.12"

  set {
    name  = "service.type"
    value = "NodePort"
  }

  set {
    name  = "ingress.enabled"
    value = true
  }

  set {
    name  = "ingress.hosts.0.name"
    value = "nginx-app.tietoevry.site"
  }

  set {
    name  = "ingress.hosts.0.path"
    value = "/*"
  }
}
