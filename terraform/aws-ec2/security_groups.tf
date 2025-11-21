locals {
  vpc_id = "vpc-03f5f6c27f69bfed2"  # use data
}

# Allow HTTP in and all out
resource "aws_security_group" "allow_http_in_all_out" {
  name        = "allow_http"
  description = "Allow HTTP inbound traffic and all outbound traffic"
  vpc_id      = local.vpc_id

  tags = {
    Name = "In HTTP"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv4" {
  security_group_id = aws_security_group.allow_http_in_all_out.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "allow_http_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_http_in_all_out.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# Allow HTTP & SSH in and all out
resource "aws_security_group" "allow_http_and_ssh_in_all_out" {
  name        = "allow_http_ssh"
  description = "Allow HTTP and SSH inbound traffic and all outbound traffic"
  vpc_id      = local.vpc_id

  tags = {
    Name = "In HTTP & SSH"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_ssh_http_ipv4" {
  security_group_id = aws_security_group.allow_http_and_ssh_in_all_out.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_ssh_ssh_ipv4" {
  security_group_id = aws_security_group.allow_http_and_ssh_in_all_out.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_http_ssh_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_http_and_ssh_in_all_out.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
