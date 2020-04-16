resource "google_service_account" "sa" {
  project      = var.project
  account_id   = var.id
  display_name = var.name
}

resource "google_project_iam_member" "sa" {
  count   = length(var.roles)
  member  = "serviceAccount:${google_service_account.sa.email}"
  project = lookup(var.roles[count.index], "project", "")
  role    = var.roles[count.index]["role"]
}

resource "google_service_account_key" "sa" {
  count = var.create_key ? 1 : 0

  service_account_id = google_service_account.sa.name
}

resource "kubernetes_secret" "sa" {
  count = var.create_secret ? 1 : 0

  metadata {
    name      = var.secret_name == "" ? var.id : var.secret_name
    namespace = var.secret_namespace

    annotations = merge(
      var.labels,
      {
        "created-with"                = "terraform"
        "google.serviceaccount.name"  = google_service_account.sa.name
        "google.serviceaccount.email" = google_service_account.sa.email
      },
    )
  }

  data = {
    (var.secret_key_name) = base64decode(google_service_account_key.sa[0].private_key)
  }
}

