variable "runner_scope" {
  type        = string
  description = "To specify repositories, use the format ':owner/:repo'. For example, 'equinix-labs/terraform-equinix-github-runner'. To specify an organization, use the format ':organization'"
}

variable "personal_access_token" {
  type        = string
  description = "GitHub PAT (Personal Access Token)"
}

variable "project_id" {
  type        = string
  description = "Your Equinix Metal project ID, where you want to deploy your server"
}
