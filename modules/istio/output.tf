output "istio_wait_id" {
  value = length(null_resource.istio_wait) > 0 ? null_resource.istio_wait[0].id : null
}
