resource "aws_security_group" "test_group" {
  name        = "test"
  description = "temp test"
  vpc_id      = data.aws_subnet.lb_subnet.vpc_id

  ingress {
    description = "local"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["172.16.0.0/12"]
  }

  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "test_group"
  }
}


resource "aws_network_interface" "tests" {
  count                   = 2
  subnet_id               = data.aws_subnet.lb_subnet.id
  security_groups         = [aws_security_group.test_group.id]
  private_ip_list_enabled = true
  private_ip_list         = [format("172.31.0.3%d", count.index + 1)]
}

resource "aws_instance" "tests" {
  count         = 2
  ami           = data.aws_ami.debian.id
  instance_type = "t3.medium"
  key_name      = aws_key_pair.kmz.key_name
  network_interface {
    network_interface_id = aws_network_interface.tests[count.index].id
    device_index         = 0
  }
  tags = {
    Name = format("test-db%d", count.index + 1)
  }
  user_data_replace_on_change = true
  user_data                   = templatefile("init/db-init.sh", { index = count.index + 1 })
}


resource "aws_network_interface" "test_client" {
  subnet_id               = data.aws_subnet.lb_subnet.id
  security_groups         = [aws_security_group.test_group.id]
  private_ip_list_enabled = true
  private_ip_list         = [var.test_client_ip]
}

resource "aws_instance" "test_client" {
  ami           = data.aws_ami.debian.id
  instance_type = "t3.medium"
  key_name      = aws_key_pair.kmz.key_name
  network_interface {
    network_interface_id = aws_network_interface.test_client.id
    device_index         = 0
  }
  tags = {
    Name = "test-client"
  }
  user_data_replace_on_change = true
  user_data = templatefile("init/client-init.sh", {
    db1_ip    = aws_network_interface.tests[0].private_ip_list[0]
    db2_ip    = aws_network_interface.tests[1].private_ip_list[0]
    lb_ext_ip = aws_instance.lb_master_cr.public_ip
    lb_int_ip = aws_network_interface.lb_master_cr.private_ip_list[0]
  })
}

output "test_db_public_ips" {
  value = aws_instance.tests[*].public_ip
}

output "test_db_private_ips" {
  value = aws_instance.tests[*].private_ip
}

output "test_client_public_ip" {
  value = aws_instance.test_client[*].public_ip
}

output "test_client_private_ip" {
  value = aws_instance.test_client[*].private_ip
}
