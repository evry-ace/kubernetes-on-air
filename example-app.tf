resource "helm_release" "example" {
  name       = "example-app"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "nginx"
  version    = "5.1.12"

  set {
    name   = "service.type"
    value = "NodePort"
  }

  set {
    name   = "ingress.enabled"
    value = true
  }

  set {
    name   = "ingress.hosts.0.name"
    value = "example.tietoevry.site"
  }

  set {
    name   = "ingress.hosts.0.path"
    value = "/*"
  }
}
