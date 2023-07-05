
provider "equinix" {}

module "example" {
  # TEMPLATE: Replace this path with the Git repo path or Terraform Registry path
  source = "../../"
  # source  = "equinix-labs/terraform-equinix-github-runner"
  # version = "0.0.1" # Use the latest version, according to https://github.com/equinix-labs/terraform-equinix-kubernetes-cluster/releases

  # Define any required variables
  project_id            = var.project_id
  personal_access_token = var.personal_access_token
  runner_scope          = var.runner_scope
  metro                 = "sv"
}
