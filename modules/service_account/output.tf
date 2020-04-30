output "key" {
  value     = element(concat(google_service_account_key.sa.*.private_key, [""]), 0)
  sensitive = true
}

output "id" {
  value = google_service_account.sa.account_id
}

output "email" {
  value = google_service_account.sa.email
}

output "secret_name" {
  value = var.secret_name
}
