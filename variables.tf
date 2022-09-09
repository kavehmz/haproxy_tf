variable "lb_binding" {
  type = map(any)
  default = {
    "http_binding" = {
      ip   = "172.31.0.11"
      port = "80"
      backend = {
        cr_master = "172.31.0.31:80"
      }
    },
    "pg_binding" = {
      ip   = "172.31.0.11"
      port = "5432"
      backend = {
        cr_master = "172.31.0.31:5432"
      }
    }
  }
}

variable "lb_ips" {
  type    = list(string)
  default = ["172.31.0.11", "172.31.0.12", "172.31.0.13", "172.31.0.14"]
}


variable "subnet_cidr" {
  type    = string
  default = "172.31.0.0/20"
}
