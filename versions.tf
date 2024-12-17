terraform {
  required_version = ">= 0.14"

  required_providers {
    equinix = {
      source  = "equinix/equinix"
      version = "~> 3.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }
  }
  provider_meta "equinix" {
    module_name = "github-action-runner"
  }
}
