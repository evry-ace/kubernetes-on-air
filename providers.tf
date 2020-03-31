terraform {
  required_providers {
    google     = "~> 3"
    external   = "~> 1"
    helm       = "~> 1"
    kubernetes = "~> 1"
    local      = "~> 1"
    null       = "~> 2"
    random     = "~> 2"
    template   = "~> 2"
    tls        = "~> 2"
  }
}

provider "google" {
  project = var.google_project
  region  = var.google_region
  zone    = var.google_zone
}

data "google_client_config" "current" {}

//provider "kubernetes" {
//  host                   = module.gke.host
//  cluster_ca_certificate = base64decode(module.gke.cluster_ca_certificate)
//  token                  = data.google_client_config.current.access_token
//  load_config_file       = false
//}
//
//provider "helm" {
//  kubernetes {
//    host = module.gke.host
//    cluster_ca_certificate = base64decode(module.gke.cluster_ca_certificate)
//    token                  = data.google_client_config.current.access_token
//    load_config_file       = false
//  }
//}
