# Local is used only to define the init template in one place and
# null_resource is used to show the content and future diffs
# none are required for functionality of any resource.
locals {
  user_data = templatefile("init/init.tftpl", {
    haproxycfg = templatefile("config/haproxy.cfg.tftpl", {
      lb_binding = var.lb_binding,
    })
    lb_ips = var.lb_ips,
  })
}

resource "null_resource" "user_data_diff_keeper" {
  triggers = {
    user_data = local.user_data
  }
}
