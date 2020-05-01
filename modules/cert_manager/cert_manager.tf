module "cert_manager_sa" {
  source = "../service_account"

  id      = "cert-manager-${var.cert_manager_id}-sa"
  name    = "cert-manager-${var.cert_manager_id}-sa"
  project = var.cert_manager_project

  roles = [{
    project = var.cert_manager_project
    role    = "roles/dns.admin"
  }]

  create_secret    = var.cert_manager_enabled
  secret_name      = "cert-manager-${var.cert_manager_id}-sa"
  secret_namespace = kubernetes_namespace.cert_manager.metadata[0].name
}

resource "kubernetes_namespace" "cert_manager" {
  metadata {
    annotations = {
      name = "cert-manager"
    }

    labels = {
      "istio-injection"    = "disabled"
      "kiali.io/member-of" = "istio-system"
    }

    name = "cert-manager"
  }
}

resource "helm_release" "cert_manager" {
  count = var.cert_manager_enabled ? 1 : 0

  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = var.cert_manager_chart_version
  namespace  = kubernetes_namespace.cert_manager.metadata[0].name
  timeout    = 1200

  set {
    name  = "installCRDs"
    value = true
  }

  set {
    name  = "ingressShim.defaultIssuerName"
    value = "letsencrypt"
  }
}

resource "helm_release" "letsencrypt" {
  count = var.cert_manager_enabled ? 1 : 0

  name       = "cert-manager-letsencrypt-issuer"
  chart      = "${path.root}/charts/letsencrypt/"
  namespace  = kubernetes_namespace.cert_manager.metadata[0].name
  timeout    = 1200
  depends_on = [helm_release.cert_manager]

  set {
    name  = "acme.http01.enabled"
    value = "False"
  }

  set {
    name  = "acme.dns01.enabled"
    value = "True"
  }

  set {
    name  = "acme.dns01.clouddns.project"
    value = var.cert_manager_project
  }

  set {
    name  = "acme.dns01.clouddns.secretName"
    value = module.cert_manager_sa.secret_name
  }
}
