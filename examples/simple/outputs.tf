output "example_runner0" {
  description = "Information about the Equinix metal device where the self-hosted runner is installed"
  sensitive   = false
  value       = module.example.devices.metal-runner-0
}
