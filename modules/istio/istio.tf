resource "google_compute_address" "istio_gateway_ip" {
  count = var.istio_enabled ? 1 : 0

  name = "istio-gateway-ip"
}

resource "helm_release" "istio" {
  count = var.istio_enabled ? 1 : 0

  name      = "istio"
  chart     = "${path.root}/charts/istio-gke/"
  namespace = var.istio_namespace

  depends_on = [helm_release.istio_operator]

  set {
    name  = "istio.version"
    value = var.istio_version
  }

  set {
    name  = "istio.mtls"
    value = var.istio_mtls_enabled
  }

  set {
    name  = "istio.sidecarInjector.rewriteAppHTTPProbe"
    value = "true"
  }

  set {
    name  = "istio.gateways.ingress.loadBalancerIP"
    value = google_compute_address.istio_gateway_ip[0].address
  }
}

resource "null_resource" "istio_wait" {
  count = var.istio_enabled ? 1 : 0

  depends_on = [helm_release.istio]
  provisioner "local-exec" {
    command = "sleep 60"
  }
}
