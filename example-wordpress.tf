resource "helm_release" "wordpress" {
  name       = "example-wordpress"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "wordpress"
  version    = "9.1.1"

  set {
    name   = "service.type"
    value = "NodePort"
  }

  set {
    name   = "ingress.enabled"
    value = true
  }

  set {
    name   = "ingress.extraHosts.0.name"
    value = "wordpless.tietoevry.site"
  }

  set {
    name   = "ingress.extraHosts.0.path"
    value = "/*"
  }

  set {
    name = "persistence.enabled"
    value = false
  }

  set {
    name = "mariadb.master.persistence.enabled"
    value = false
  }
}
