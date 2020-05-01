module "service_account" {
  source = "../service_account"

  id      = "external-dns-aks-sa"
  name    = "external-dns-aks-sa"
  project = var.dns_project

  roles = [{
    project = var.dns_project
    role    = "roles/dns.admin"
  }]

  create_secret    = true
  secret_name      = "external-dns-aks-sa"
  secret_namespace = "kube-system"
}

resource "helm_release" "external_dns" {
  count = var.aks_enabled && var.external_dns_enabled ? 1 : 0

  name       = "external-dns"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "external-dns"
  version    = "2.22.0"
  namespace  = "kube-system"
  timeout    = 600

  depends_on = [azurerm_kubernetes_cluster.example[0]]

  set {
    name  = "policy"
    value = "upsert-only"
  }

  set {
    name  = "sources"
    value = "{ingress,service,istio-gateway}"
  }

  set {
    name  = "provider"
    value = "google"
  }

  set {
    name  = "google.project"
    value = var.dns_project
  }

  set {
    name  = "google.serviceAccountSecret"
    value = module.service_account.secret_name
  }

  set {
    name  = "google.serviceAccountSecretKey"
    value = "credentials.json"
  }
}
