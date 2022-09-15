variable "lb_binding" {
  type = map(any)
  default = {
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
  default = ["172.31.0.11"]
}

variable "test_client_ip" {
  type    = string
  default = "172.31.0.40"
}


variable "subnet_cidr" {
  type    = string
  default = "172.31.0.0/20"
}
