resource "kubernetes_namespace" "istio_bookinfo" {
  count = var.istio_bookinfo_enabled ? 1 : 0

  metadata {
    name = var.istio_bookinfo_namespace

    labels = {
      "istio-injection"    = "enabled"
      "kiali.io/member-of" = "istio-system"
    }
  }
}

resource "helm_release" "istio_bookinfo" {
  count = var.istio_bookinfo_enabled ? 1 : 0

  name       = "istio-bookinfo"
  namespace  = kubernetes_namespace.istio_bookinfo[0].metadata[0].name
  repository = "https://evry-ace.github.io/helm-charts"
  chart      = "istio-bookinfo"
  version    = var.istio_bookinfo_version

  depends_on = [null_resource.istio_wait]

  set {
    name  = "gateway.hostname"
    value = var.istio_bookinfo_hostname
  }

  set {
    name  = "gateway.tls.enabled"
    value = true
  }

  set {
    name  = "gateway.tls.acme.enabled"
    value = true
  }

  set {
    name  = "gateway.httpsRedirect"
    value = true
  }
}
