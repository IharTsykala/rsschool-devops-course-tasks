resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

resource "aws_eip_association" "nat_eip_assoc" {
  allocation_id        = aws_eip.nat_eip.id
  network_interface_id = aws_network_interface.nat_eni.id
}

resource "aws_network_interface" "nat_eni" {
  subnet_id       = aws_subnet.public_subnet_1.id
  security_groups = [aws_security_group.security_group_public_from_nat.id]

  tags = {
    Name = "nat-eni"
  }
}
