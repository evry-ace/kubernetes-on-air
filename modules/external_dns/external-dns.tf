module "service_account" {
  source = "../service_account"

  id          = "external-dns-aks-sa"
  description = "external-dns-aks-sa"

  roles = [{
    project = ""
    role    = "roles/dns.admin"
  }]

  create_secret    = true
  secret_name      = "external-dns-aks-sa"
  secret_namespace = "kube-system"
}
