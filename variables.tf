variable "lb_binding" {
  type = map(any)
  default = {
    "first_binding" = {
      ip = "172.31.0.11"
      backend = {
        cr_master = "192.168.1.1:5432"
      }
    }
  }
}

variable "lb_ips" {
  type    = list(string)
  default = ["172.31.0.11", "172.31.0.12", "172.31.0.13", "172.31.0.14"]
}


variable "subnet_id" {
  type    = string
  default = "subnet-0ca900a17d26d5103"
}
