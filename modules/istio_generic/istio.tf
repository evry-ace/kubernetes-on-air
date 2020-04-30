resource "helm_release" "istio" {
  count = var.istio_enabled ? 1 : 0

  name      = "istio"
  chart     = "${path.root}/charts/${var.istio_chart_name}/"
  namespace = var.istio_namespace

  depends_on = [helm_release.istio_operator]

  set {
    name  = "istio.version"
    value = var.istio_version
  }

  set {
    name  = "istio.meshPolicy.mtlsMode"
    value = var.istio_mtls_mode
  }

  set {
    name  = "istio.sidecarInjector.rewriteAppHTTPProbe"
    value = "true"
  }

  set {
    name  = "istio.gateways.ingress.loadBalancerIP"
    value = var.istio_ingress_gateway_ip
  }
}

resource "null_resource" "istio_wait" {
  count = var.istio_enabled ? 1 : 0

  depends_on = [helm_release.istio]
  provisioner "local-exec" {
    command = "sleep 60"
  }
}
