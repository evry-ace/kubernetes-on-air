resource "azurerm_resource_group" "example" {
  name     = "aks-demo"
  location = "West Europe"
}

resource "azurerm_container_registry" "example" {
  name                = "evryflaatten"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku                 = "Premium"
  admin_enabled       = true
}

resource "azurerm_kubernetes_cluster" "example" {
  count = var.aks_enabled ? 1 : 0

  name                = "aks-demo"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  dns_prefix          = "aksdemo"

  #network_profile {
  #  network_plugin = "kubenet"
  #  network_policy = "calico"
  #}

  default_node_pool {
    name    = "default"
    type    = "VirtualMachineScaleSets"
    vm_size = "Standard_D2_v2"

    enable_auto_scaling = true
    max_count           = 10
    min_count           = 1
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
}

output "host" {
  value     = azurerm_kubernetes_cluster.example[0].kube_config.0.host
  sensitive = true
}

output "username" {
  value     = azurerm_kubernetes_cluster.example[0].kube_config.0.username
  sensitive = true
}

output "password" {
  value     = azurerm_kubernetes_cluster.example[0].kube_config.0.password
  sensitive = true
}

output "client_certificate" {
  value     = azurerm_kubernetes_cluster.example[0].kube_config.0.client_certificate
  sensitive = true
}

output "client_key" {
  value     = azurerm_kubernetes_cluster.example[0].kube_config.0.client_key
  sensitive = true
}

output "cluster_ca_certificate" {
  value     = azurerm_kubernetes_cluster.example[0].kube_config.0.cluster_ca_certificate
  sensitive = true
}
