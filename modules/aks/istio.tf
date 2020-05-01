resource "azurerm_public_ip" "istio" {
  name                = "istio-ingress"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  allocation_method   = "Static"

  tags = {
    environment = "Production"
  }
}

module "istio" {
  source = "../istio_generic"

  nodepool = azurerm_kubernetes_cluster.example[0].id

  istio_operator_namespace     = "istio-system"
  istio_operator_chart_version = "0.0.46"
  istio_operator_version       = "0.5.6"

  istio_enabled            = var.aks_enabled && var.istio_enabled
  istio_chart_name         = "istio-aks"
  istio_namespace          = "istio-system"
  istio_major              = "1.5"
  istio_version            = "1.5.1"
  istio_mtls_mode          = "PERMISSIVE"
  istio_ingress_gateway_ip = azurerm_public_ip.istio.ip_address

  kiali_enabled          = var.aks_enabled && var.istio_enabled && var.kiali_enabled
  kiali_operator_version = "1.2.0"
  kiali_version          = "1.16.0"
  kiali_ingress_host     = "kiali.aks.tietoevry.site"

  istio_bookinfo_enabled   = var.aks_enabled && var.istio_enabled && var.bookinfo_enabled
  istio_bookinfo_hostname  = "bookinfo.aks.tietoevry.site"
  istio_bookinfo_namespace = "bookinfo"
  istio_bookinfo_version   = "1.2.2"
}
