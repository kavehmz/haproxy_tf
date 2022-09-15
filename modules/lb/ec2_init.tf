# just defining the template
locals {
  user_data = templatefile("${path.module}/init/init.tftpl", {
    hostname = var.hostname
    dd_key   = var.dd_key
    haproxycfg = templatefile("${path.module}/config/haproxy.cfg.tftpl", {
      lb_binding = var.lb_binding,
    })
    lb_ips = var.lb_ips,
  })
}
