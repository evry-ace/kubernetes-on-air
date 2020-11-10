resource "kubernetes_namespace" "flux" {
  metadata {
    name = "flux"

    labels = {
      "istio-injection" = "disabled"
    }
  }
}

resource "helm_release" "flux" {
  name       = "flux"
  namespace  = kubernetes_namespace.flux.metadata[0].name
  repository = "https://charts.fluxcd.io"
  chart      = "flux"
  version    = "1.5.0"

  set {
    name  = "git.url"
    value = "git@github.com:evry-ace/kubernetes-on-air"
  }

  set {
    name  = "git.path"
    value = "gitops/"
  }

  set {
    name  = "registry.includeImage"
    value = "eu.gcr.io/evry-flaatten/*"
  }

  set {
    name  = "prometheus.enabled"
    value = true
  }

  set {
    name  = "prometheus.serviceMonitor.create"
    value = true
  }

  set {
    name  = "syncGarbageCollection.enabled"
    value = true
  }

  set {
    name  = "dashboards.enabled"
    value = true
  }
}

resource "helm_release" "helm_operator" {
  name       = "helm-operator"
  namespace  = kubernetes_namespace.flux.metadata[0].name
  repository = "https://charts.fluxcd.io"
  chart      = "helm-operator"
  version    = "1.2.0"

  set {
    name  = "helm.versions"
    value = "v3"
  }

  depends_on = [helm_release.flux]
}
