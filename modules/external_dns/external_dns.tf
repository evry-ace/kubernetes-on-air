module "service_account" {
  source = "../service_account"

  id      = "external-dns-${var.external_dns_id}-sa"
  name    = "external-dns-${var.external_dns_id}-sa"
  project = var.external_dns_project

  roles = [{
    project = var.external_dns_project
    role    = "roles/dns.admin"
  }]

  create_secret    = true
  secret_name      = "external-dns-${var.external_dns_id}-sa"
  secret_namespace = kubernetes_namespace.external_dns.metadata[0].name
}

resource "kubernetes_namespace" "external_dns" {
  metadata {
    annotations = {
      name = var.external_dns_namespace
    }

    labels = {
      "istio-injection"    = "disabled"
      "kiali.io/member-of" = "istio-system"
    }

    name = var.external_dns_namespace
  }
}

resource "helm_release" "external_dns" {
  count = var.external_dns_enabled ? 1 : 0

  name       = "external-dns"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "external-dns"
  version    = var.external_dns_chart_version
  namespace  = kubernetes_namespace.external_dns.metadata[0].name
  timeout    = 600

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
    value = var.external_dns_project
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
