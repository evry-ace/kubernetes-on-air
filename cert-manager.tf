resource "google_service_account" "cert_manager" {
  account_id   = "cert-manager"
  display_name = "Kubernetes cert-manager service account"
}

resource "google_project_iam_member" "cert_manager" {
  role   = "roles/dns.admin"
  member = "serviceAccount:${google_service_account.cert_manager.email}"

  depends_on = [google_project_service.cloudresourcemanager]
}

resource "google_service_account_key" "cert_manager" {
  service_account_id = google_service_account.cert_manager.name
}

resource "kubernetes_namespace" "cert_manager" {
  metadata {
    annotations = {
      name = "cert-manager"
    }

    labels = {
      "istio-injection" = "disabled"
    }

    name = "cert-manager"
  }
}

resource "kubernetes_secret" "cert_manager" {
  metadata {
    name      = "cert-manager-service-account"
    namespace = kubernetes_namespace.cert_manager.metadata[0].name
  }

  data = {
    "credentials.json" = base64decode(google_service_account_key.cert_manager.private_key)
  }
}

resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "v0.15.0-alpha.0"
  namespace  = kubernetes_namespace.cert_manager.metadata[0].name
  timeout    = 1200

  depends_on = [google_container_node_pool.apps]

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
    value = var.google_project
  }

  set {
    name  = "acme.dns01.clouddns.secretName"
    value = kubernetes_secret.cert_manager.metadata[0].name
  }
}
