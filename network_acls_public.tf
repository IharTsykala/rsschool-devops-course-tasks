resource "aws_network_acl" "network_acls_public" {
  vpc_id = aws_vpc.main.id

  subnet_ids = [
    aws_subnet.public_subnet_1.id,
    aws_subnet.public_subnet_2.id,
  ]

  tags = {
    Name = "public-nacl"
  }
}

resource "aws_network_acl_rule" "ssh_inbound" {
  network_acl_id = aws_network_acl.network_acls_public.id
  rule_number    = 100
  protocol       = "6"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 22
  to_port        = 22
  egress         = false
}

resource "aws_network_acl_rule" "http_inbound" {
  network_acl_id = aws_network_acl.network_acls_public.id
  rule_number    = 110
  protocol       = "6"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 80
  to_port        = 80
  egress         = false
}

resource "aws_network_acl_rule" "all_outbound" {
  network_acl_id = aws_network_acl.network_acls_public.id
  rule_number    = 100
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
  egress         = true
}
