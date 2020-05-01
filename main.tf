module "monitoring" {
  source = "./modules/monitoring"
}

module "istio" {
  source = "./modules/istio"

  gke_nodepool = google_container_node_pool.apps.name

  istio_operator_namespace     = "istio-system"
  istio_operator_chart_version = "0.0.45"
  istio_operator_version       = "0.4.13"

  istio_enabled      = true
  istio_namespace    = "istio-system"
  istio_major        = "1.4"
  istio_version      = "1.4.7"
  istio_mtls_enabled = false

  kiali_enabled          = true
  kiali_operator_version = "1.2.0"
  kiali_version          = "1.16.0"
  kiali_ingress_host     = "kiali.${var.ingress_dns}"

  istio_bookinfo_enabled   = true
  istio_bookinfo_hostname  = "bookinfo.${var.ingress_dns}"
  istio_bookinfo_namespace = "bookinfo"
  istio_bookinfo_version   = "1.2.2"
}

//module "aks" {
//  source = "./modules/aks"
//  providers = {
//    kubernetes = kubernetes.aks
//    helm       = helm.aks
//  }
//
//  dns_project = var.google_project
//
//  aks_enabled = false
//}
