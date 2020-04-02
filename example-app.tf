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
    name  = "ingress.hostname"
    value = ""
  }

  set {
    name  = "ingress.hosts[0].name"
    value = "nginx-app.tietoevry.site"
  }

  set {
    name  = "ingress.hosts[0].path"
    value = "/*"
  }

  set {
    name  = "ingress.hosts[1].name"
    value = "fredrik-app.tietoevry.site"
  }

  set {
    name  = "ingress.hosts[1].path"
    value = "/*"
  }

  set {
    name  = "ingress.hosts[2].name"
    value = "magnus-app.tietoevry.site"
  }

  set {
    name  = "ingress.hosts[2].path"
    value = "/*"
  }
}
