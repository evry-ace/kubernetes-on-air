variable "cluster_id" {}
variable "cert_manager_enabled" {
  default = true
}
variable "cert_manager_id" {}
variable "cert_manager_project" {}
variable "cert_manager_chart_version" {}
variable "cert_manager_namespace" {
  default = "external-dns"
}
