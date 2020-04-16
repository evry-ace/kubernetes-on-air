resource "kubernetes_namespace" "prometheus" {
  metadata {
    name = "monitoring"

    labels = {
      "istio-injection" = "disabled"
    }
  }
}

data "template_file" "prometheus_operator_config" {
  template = file("${path.root}/config/prometheus-operator/config.yaml")
  vars = {
    external_dns_ingress_dns = "tietoevry.site"

    istio_secret = "${true ? "[istio.default, istio.prometheus-operator-prometheus]" : "[]"}"

    alertmanager_tls_secret_name = "alertmanager-${replace("tietoevry.site", ".", "-")}-tls"

    grafana_tls_secret_name = "grafana-${replace("tietoevry.site", ".", "-")}-tls"

    prometheus_operator_create_crd = true
    prometheus_tls_secret_name     = "prometheus-${replace("tietoevry.site", ".", "-")}-tls"
  }
}

resource "helm_release" "prometheus-operator" {
  name       = "prometheus-operator"
  namespace  = kubernetes_namespace.prometheus.metadata[0].name
  repository = "https://kubernetes-charts.storage.googleapis.com"
  chart      = "prometheus-operator"
  version    = "8.12.13"

  values = [
    data.template_file.prometheus_operator_config.rendered
  ]
}

resource "kubernetes_config_map" "grafana_dashboards" {
  metadata {
    name      = "grafana-istio-dashboards"
    namespace = kubernetes_namespace.prometheus.metadata[0].name

    labels = {
      grafana_dashboard = "1"
    }
  }

  data = {
    "citadel-dashboard.json"           = file("${path.root}/config/grafana/dashboards/citadel-dashboard.json")
    "galley-dashboard.json"            = file("${path.root}/config/grafana/dashboards/galley-dashboard.json")
    "istio-mesh-dashboard.json"        = file("${path.root}/config/grafana/dashboards/istio-mesh-dashboard.json")
    "istio-performance-dashboard.json" = file("${path.root}/config/grafana/dashboards/istio-performance-dashboard.json")
    "istio-service-dashboard.json"     = file("${path.root}/config/grafana/dashboards/istio-service-dashboard.json")
    "istio-workload-dashboard.json"    = file("${path.root}/config/grafana/dashboards/istio-workload-dashboard.json")
    "mixer-dashboard.json"             = file("${path.root}/config/grafana/dashboards/mixer-dashboard.json")
    "pilot-dashboard.json"             = file("${path.root}/config/grafana/dashboards/pilot-dashboard.json")
  }
}
