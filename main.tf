

resource "equinix_metal_device" "runner" {
  count = var.server_count

  depends_on = [null_resource.delete_script]

  hostname         = "metal-runner-${count.index}"
  plan             = var.plan
  metro            = var.metro
  operating_system = var.operating_system
  billing_cycle    = "hourly"
  project_id       = var.project_id

  user_data = templatefile("${path.module}/templates/user-data.tftpl", {
    personal_access_token = var.personal_access_token,
    runner_scope          = var.runner_scope,
    }
  )

  tags = ["github-action-runner", "terraform"]
}

locals {
  nonsensitive_pat = nonsensitive(var.personal_access_token)
}

resource "null_resource" "wait" {
  count = var.server_count

  triggers = {
    id       = equinix_metal_device.runner[count.index].id
    hostname = equinix_metal_device.runner[count.index].hostname
  }

  provisioner "local-exec" {
    quiet   = true
    command = "/bin/bash ${path.module}/scripts/wait-runner-online.sh ${var.runner_scope} ${self.triggers.hostname}"

    environment = {
      RUNNER_CFG_PAT = local.nonsensitive_pat
    }
  }
}

resource "null_resource" "delete_script" {
  count = var.server_count

  triggers = {
    hostname     = "metal-runner-${count.index}"
    runner_scope = var.runner_scope
    pat          = var.personal_access_token
  }

  provisioner "local-exec" {
    when    = destroy
    quiet   = true
    command = "/bin/bash ${path.module}/scripts/delete-runner.sh ${self.triggers.runner_scope} ${self.triggers.hostname}"

    environment = {
      RUNNER_CFG_PAT = self.triggers.pat
    }
  }
}
