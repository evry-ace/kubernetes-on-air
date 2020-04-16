variable "project" {
  description = "The Google Cloud project where the service account will be created in. Defaults to the project the provider is set up to use."
  default     = ""
}

variable "id" {
  description = "The account id that is used to generate the service account email address and a stable unique id. It is unique within a project, must be 6-30 characters long, and match the regular expression [a-z]([-a-z0-9]*[a-z0-9]) to comply with RFC1035. Changing this forces a new service account to be created."
}

variable "name" {
  description = "The display name for the service account. Can be updated without creating a new resource."
}

variable "roles" {
  description = "The roles that should be applied. Note that custom roles must be of the format [projects|organizations]/{parent-name}/roles/{role-name}."
  type        = list(object({ project = string, role = string }))
  default     = []
}

variable "labels" {
  description = "Labels that will be added to the created resources"
  type        = map(string)
  default     = {}
}

variable "create_key" {
  description = "Creates and manages service account key-pairs, which allow the user to establish identity of a service account outside of GCP."
  type        = string
  default     = true
}

variable "create_secret" {
  description = "Creates a corresponding secret in Kubernetes for the key of the service account"
  type        = string
  default     = false
}

variable "secret_key_name" {
  description = "Filename for the service account key in the Kubernetes secret, defaults to credentials.json."
  default     = "credentials.json"
}

variable "secret_name" {
  description = "Name of the secret in Kubernetes, default to the id of the service account."
  default     = ""
}

variable "secret_namespace" {
  description = "Namespace the Kubernetes secret will be created in"
  default     = ""
}

