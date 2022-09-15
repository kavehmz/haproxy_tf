
resource "aws_network_interface" "lb_master_cr" {
  subnet_id       = data.aws_subnet.lb_subnet.id
  security_groups = [aws_security_group.lb_group.id]

  # IP addresses per network interface per instance type
  # https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-eni.html#AvailableIpPerENI
  private_ip_list_enabled = true
  private_ip_list         = var.lb_ips

  tags = {
    Name = "lb_master_cr"
  }
}


resource "null_resource" "user_data_diff_keeper" {
  triggers = {
    user_data = local.user_data
  }
}

resource "aws_instance" "lb_master_cr" {
  ami                         = data.aws_ami.debian.id
  instance_type               = "t3.medium"
  user_data                   = local.user_data
  user_data_replace_on_change = true
  key_name                    = aws_key_pair.tf.key_name

  network_interface {
    network_interface_id = aws_network_interface.lb_master_cr.id
    device_index         = 0
  }

  tags = {
    Name = "lb_master_cr"
  }
}

output "lb_master_cr_public_ip" {
  value = aws_instance.lb_master_cr.public_ip
}

