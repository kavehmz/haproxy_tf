module "lb" {
  source          = "../../../modules/lb"
  subnet_id       = data.aws_subnet.lb.id
  security_groups = [aws_security_group.lb.id]
  lb_ips          = var.lb_ips
  lb_tags         = var.lb_tags
  ami             = data.aws_ami.debian.id
  key_name        = aws_key_pair.lb.key_name
  hostname        = var.hostname
  dd_key          = var.dd_key
}

output "lb_public_ip" {
  value = module.lb.lb_public_ip
}
