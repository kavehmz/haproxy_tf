data "aws_ami" "debian" {
  most_recent = true

  filter {
    name   = "name"
    values = ["debian-11-amd64-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["136693071363"]
}

resource "aws_key_pair" "tf" {
  key_name   = "tf"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDiWX8vhtCS76J4o0tWaf8vSWMzbWmL3+3o+cN3Ac6D/ tf"
}

data "aws_subnet" "lb_subnet" {
  filter {
    name   = "cidr-block"
    values = [var.subnet_cidr]
  }
}

locals {
  user_data = templatefile("init/init.tftpl", {
    haproxycfg = templatefile("config/haproxy.cfg.tftpl", {
      lb_binding = var.lb_binding,
    })
    lb_ips = var.lb_ips,
  })
}
