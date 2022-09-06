variable "db_binding" {
  type = map(any)
  default = {
    "first_binding" = {
      ip = "172.31.0.11"
      backend = {
        cr_master = "192.168.1.1"
      }
    }
  }
}
