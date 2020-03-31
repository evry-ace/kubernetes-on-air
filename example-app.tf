resource "helm_release" "example" {
  name       = "example-app"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "nginx"
  version    = "5.1.12"
}
