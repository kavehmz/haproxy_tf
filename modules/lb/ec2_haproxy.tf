
resource "aws_network_interface" "lb" {
  subnet_id               = var.subnet_id
  private_ip_list_enabled = true
  private_ip_list         = var.lb_ips
  tags                    = var.lb_tags
  security_groups         = var.security_groups
}

resource "aws_eip" "ip" {
  depends_on = [
    aws_instance.lb
  ]
  vpc                       = true
  network_interface         = aws_network_interface.lb.id
  associate_with_private_ip = var.lb_ips[0]
}

resource "aws_instance" "lb" {
  ami                         = var.ami
  instance_type               = "t3.medium"
  user_data                   = local.user_data
  user_data_replace_on_change = true
  key_name                    = var.key_name
  monitoring                  = true
  tags                        = var.lb_tags

  network_interface {
    network_interface_id = aws_network_interface.lb.id
    device_index         = 0
  }
}
