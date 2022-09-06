resource "aws_network_interface" "testvm" {
  subnet_id   = "subnet-088efd4fa0ae9d633"
  private_ips = ["172.31.0.10"]

  tags = {
    Name = "primary_network_interface"
  }
}

resource "aws_instance" "testvm" {
  # Debian 11 (HVM), SSD Volume Type 
  ami               = data.aws_ami.debian.id
  instance_type     = "t3.micro"
  availability_zone = "us-east-1a"

  network_interface {
    network_interface_id = aws_network_interface.testvm.id
    device_index         = 0
  }

  tags = {
    Name = "testvm"
  }


  key_name = aws_key_pair.kmz.key_name
}

output "testvm_public_ip" {
  value = aws_instance.testvm.public_ip
}

