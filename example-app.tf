resource "helm_release" "nginx_app" {
  name         = "nginx-app"
  repository   = "https://charts.bitnami.com/bitnami"
  chart        = "nginx"
  version      = "5.1.12"
  timeout      = 600

  depends_on = [google_container_node_pool.apps]

  set {
    name  = "service.type"
    value = "NodePort"
  }

  set {
    name  = "ingress.enabled"
    value = true
  }

  set {
    name  = "ingress.certManager"
    value = true
  }

  set {
    name  = "ingress.hostname"
    value = ""
  }

  set_string {
    name  = "ingress.annotations.cert-manager\\.io/cluster-issuer"
    value = "letsencrypt"
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

  set {
    name  = "ingress.hosts[3].name"
    value = "tomstian-app.tietoevry.site"
  }

  set {
    name  = "ingress.hosts[3].path"
    value = "/*"
  }

  set {
    name  = "ingress.tls[0].secretName"
    value = "example-app-tls"
  }

  set {
    name  = "ingress.tls[0].hosts[0]"
    value = "nginx-app.tietoevry.site"
  }

  set {
    name  = "ingress.tls[0].hosts[0]"
    value = "nginx-app.tietoevry.site"
  }

  set {
    name  = "ingress.tls[0].hosts[1]"
    value = "fredrik-app.tietoevry.site"
  }

  set {
    name  = "ingress.tls[0].hosts[2]"
    value = "magnus-app.tietoevry.site"
  }

  set {
    name  = "ingress.tls[0].hosts[3]"
    value = "tomstian-app.tietoevry.site"
  }
}
