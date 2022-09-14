variable "subnet_id" {
  type = string
}

variable "security_groups" {
  type = list(string)
}

variable "lb_ips" {
  type = list(string)
}

variable "lb_tags" {
  type = map(string)
}

variable "ami" {
  type = string
}

variable "key_name" {
  type = string
}

# TODO: Remove
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
