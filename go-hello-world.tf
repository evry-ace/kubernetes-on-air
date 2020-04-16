resource "google_cloudbuild_trigger" "go_app" {
  provider = google-beta

  github {
    owner = "evry-ace"
    name  = "kubernetes-on-air"

    push {
      branch = "master"
    }
  }

  included_files = ["apps/hello-world/**"]

  substitutions = {
    _FOO = "bar"
    _BAZ = "qux"
  }

  filename = "apps/hello-world/cloudbuild.yaml"
}

resource "helm_release" "go_app" {
  name    = "go-hello-world"
  chart   = "./charts/go-hello-world"
  timeout = 600

  depends_on = [google_container_node_pool.apps]

  set {
    name  = "image.repository"
    value = "eu.gcr.io/evry-flaatten/go-hello-world"
  }

  set {
    name  = "image.tag"
    value = "latest"
  }

  set {
    name  = "service.type"
    value = "NodePort"
  }

  set {
    name  = "ingress.enabled"
    value = true
  }

  set_string {
    name  = "ingress.annotations.cert-manager\\.io/cluster-issuer"
    value = "letsencrypt"
  }

  set_string {
    name  = "ingress.annotations.kubernetes\\.io/tls-acme"
    value = "true"
  }

  set {
    name  = "ingress.hosts[0].name"
    value = "go-app.tietoevry.site"
  }

  set {
    name  = "ingress.hosts[0].paths[0]"
    value = "/*"
  }

  set {
    name  = "ingress.tls[0].secretName"
    value = "go-app-tls"
  }

  set {
    name  = "ingress.tls[0].hosts[0]"
    value = "go-app.tietoevry.site"
  }
}
