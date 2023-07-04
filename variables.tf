variable "runner_scope" {
  type        = string
  description = "repo (:owner/:repo) or org (:organization)"
}

variable "personal_access_token" {
  type        = string
  description = "GitHub PAT (Personal Access Token)"
}

variable "metal_project_id" {
  type        = string
  description = "Your Equinix Metal project ID, where you want to deploy your server"
}

variable "plan" {
  type        = string
  description = "Metal server type you plan to deploy"
  default     = "c3.small.x86"
}

variable "operating_system" {
  type        = string
  description = "OS you want to deploy"
  default     = "ubuntu_20_04"
}

variable "metro" {
  type        = string
  description = "Metal's Metro location you want to deploy your servers to"
  default     = "ny"
}

variable "server_count" {
  type        = number
  description = "numbers of servers you want to deploy"
  default     = 1
}
