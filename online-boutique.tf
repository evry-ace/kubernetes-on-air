locals {
  apps = [
    "adservice",
    "cartservice",
    "checkoutservice",
    "currencyservice",
    "emailservice",
    "frontend",
    "loadgenerator",
    "paymentservice",
    "productcatalogservice",
    "recommendationservice",
    "shippingservice",
  ]
}

resource "google_cloudbuild_trigger" "online_boutique" {
  provider = google-beta

  count = length(local.apps)

  name = "online-boutique-${local.apps[count.index]}-build"

  github {
    owner = "evry-ace"
    name  = "kubernetes-on-air"

    push {
      branch = "master"
    }
  }

  included_files = ["apps/online-boutique"]

  substitutions = {
    _APP_NAME  = "online-boutique/${local.apps[count.index]}"
    _BUILD_DIR = "apps/online-boutique/src/${local.apps[count.index]}"
  }

  filename = "apps/cloudbuild.yaml"
}
