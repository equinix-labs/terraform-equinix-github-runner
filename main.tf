resource "equinix_metal_device" "runner" {
  count = var.server_count

  depends_on = [null_resource.delete_script]

  hostname         = "metal-runner-${count.index}"
  plan             = var.plan
  metro            = var.metro
  operating_system = var.operating_system
  billing_cycle    = "hourly"
  project_id       = var.metal_project_id

  user_data = templatefile("scripts/user-data.sh", {
    personal_access_token = var.personal_access_token,
    runner_scope          = var.runner_scope,
    }
  )

  tags = ["github-action-runner", "terraform"]
}

resource "null_resource" "wait" {
  count = var.server_count

  triggers = {
    hostname     = equinix_metal_device.runner[count.index].hostname
    runner_scope = var.runner_scope
    pat          = var.personal_access_token
  }

  provisioner "local-exec" {
    quiet   = true
    command = "/bin/bash ${path.module}/scripts/wait-runner-online.sh ${self.triggers.runner_scope} ${self.triggers.hostname}"

    environment = {
      RUNNER_CFG_PAT = self.triggers.pat
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
