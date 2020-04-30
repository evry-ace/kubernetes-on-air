resource "kubernetes_namespace" "istio" {
  metadata {
    name = var.istio_operator_namespace

    labels = {
      "istio-injection"    = "disabled"
      "kiali.io/member-of" = "istio-system"
    }
  }
}

resource "helm_release" "istio_operator" {
  name       = "istio-operator"
  namespace  = kubernetes_namespace.istio.metadata[0].name
  repository = "https://kubernetes-charts.banzaicloud.com"
  chart      = "istio-operator"
  version    = var.istio_operator_chart_version

  set {
    name  = "operator.image.tag"
    value = var.istio_operator_version
  }

  set {
    name  = "istioVersion"
    value = var.istio_major
  }
}
