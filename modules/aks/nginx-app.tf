resource "helm_release" "nginx_app" {
  count = var.aks_enabled && var.nginx_app_enabled ? 1 : 0

  name       = "nginx-app"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "nginx"
  version    = "5.1.12"
  timeout    = 600

  depends_on = [azurerm_kubernetes_cluster.example[0]]

  set {
    name  = "service.type"
    value = "ClusterIP"
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

  set_string {
    name  = "ingress.annotations.kubernetes\\.io/ingress\\.class"
    value = "nginx"
  }

  set {
    name  = "ingress.hosts[0].name"
    value = "nginx-aks.tietoevry.site"
  }

  set {
    name  = "ingress.hosts[0].path"
    value = "/*"
  }

  set {
    name  = "ingress.tls[0].secretName"
    value = "nginx-aks-tls"
  }

  set {
    name  = "ingress.tls[0].hosts[0]"
    value = "nginx-aks.tietoevry.site"
  }
}
