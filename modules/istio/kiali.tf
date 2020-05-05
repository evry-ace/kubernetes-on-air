resource "helm_release" "kiali_operator" {
  count = var.istio_enabled && var.kiali_enabled ? 1 : 0

  name       = "kiali-operator"
  namespace  = kubernetes_namespace.istio.metadata[0].name
  repository = "https://evry-ace.github.io/helm-charts"
  chart      = "kiali-operator"
  version    = var.kiali_operator_version

  depends_on = [null_resource.istio_wait]

  set {
    name  = "kiali.enabled"
    value = var.kiali_enabled
  }

  set {
    name  = "kiali.spec.api.namespaces.exclude"
    value = "{cert-manager,kube-system,kube-public,monitoring}"
  }

  set {
    name  = "kiali.spec.auth.strategy"
    value = "anonymous"
  }

  values = [
    <<EOF
kiali:
  spec:
    identity:
      cert_file: ""
      private_key_file: ""
EOF
    ,
  ]

  set {
    name  = "kiali.spec.deployment.image_version"
    value = "v${var.kiali_version}"
  }

  set {
    name  = "kiali.spec.deployment.service_type"
    value = "NodePort"
  }

  set {
    name  = "kiali.spec.deployment.ingress_enabled"
    value = false
  }

  set {
    name  = "kiali.spec.external_services.grafana.enabled"
    value = false
  }

  set {
    name  = "kiali.spec.external_services.tracing.enabled"
    value = false
  }

  set {
    name  = "kiali.spec.external_services.prometheus.url"
    value = "http://prometheus-operator-prometheus.monitoring:9090"
  }
}

resource "kubernetes_ingress" "kiali" {
  count = var.istio_enabled && var.kiali_enabled ? 1 : 0

  metadata {
    name      = "kiali-custom-ingress"
    namespace = kubernetes_namespace.istio.metadata[0].name

    annotations = {
      "kubernetes.io/ingress.class"               = "gce"
      "cert-manager.io/cluster-issuer"            = "letsencrypt"
      "kubernetes.io/tls-acme"                    = "true"
      "external-dns.alpha.kubernetes.io/hostname" = "${var.kiali_ingress_host}"
    }
  }

  spec {
    tls {
      hosts       = [var.kiali_ingress_host]
      secret_name = "${replace(var.kiali_ingress_host, ".", "-")}-tls"
    }

    rule {
      host = var.kiali_ingress_host
      http {
        path {
          path = "/*"
          backend {
            service_name = "kiali"
            service_port = "20001"
          }
        }
      }
    }
  }
}
