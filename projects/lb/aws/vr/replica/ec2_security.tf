resource "aws_security_group" "lb" {
  name        = "HaProxy LB Security Group"
  description = "HaProxy LB Security Group"
  tags        = var.lb_tags
  vpc_id      = data.aws_subnet.lb.vpc_id

  ingress {
    description = "local"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["172.16.0.0/12", "10.0.0.0/8"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
