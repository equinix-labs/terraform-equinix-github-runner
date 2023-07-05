output "devices" {
  description = "List of metal devices with self-hosted runner installed"
  sensitive   = false
  value = { for idx, device in equinix_metal_device.runner : device.hostname => {
    id          = device.id
    public_ipv4 = device.access_public_ipv4
  } }
}
