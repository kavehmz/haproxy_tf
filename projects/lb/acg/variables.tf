variable "lb_binding" {
  type = map(any)
  default = {
    "pg_binding" = {
      ip   = ""
      port = "5432"
      backend = {
        cr_master = "172.30.12.78:5432"
      }
    }
  }
}

variable "lb_ips" {
  type    = list(string)
  default = ["172.31.16.100"]
}

variable "subnet_cidr" {
  type    = string
  default = "172.31.16.0/20"
}

variable "lb_tags" {
  type = map(string)
  default = {
    Name = "demo"
  }
}
