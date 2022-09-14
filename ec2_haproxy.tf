
resource "aws_network_interface" "lb" {
  subnet_id               = data.aws_subnet.lb.id
  security_groups         = [aws_security_group.lb.id]
  private_ip_list_enabled = true
  private_ip_list         = var.lb_ips
  tags                    = var.lb_tags
}

resource "aws_eip" "ip" {
  vpc                       = true
  network_interface         = aws_network_interface.lb.id
  associate_with_private_ip = var.lb_ips[0]
}

resource "aws_instance" "lb" {
  ami                         = data.aws_ami.debian.id
  instance_type               = "t3.medium"
  user_data                   = local.user_data
  user_data_replace_on_change = true
  key_name                    = aws_key_pair.lb.key_name
  monitoring                  = true
  tags                        = var.lb_tags

  network_interface {
    network_interface_id = aws_network_interface.lb.id
    device_index         = 0
  }


}

output "lb_master_cr_public_ip" {
  value = aws_instance.lb.public_ip
}

