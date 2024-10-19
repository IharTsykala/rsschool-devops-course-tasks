resource "aws_route_table" "routes_private_nat" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block           = "0.0.0.0/0"
    network_interface_id = aws_network_interface.nat_eni.id
  }

  tags = {
    Name = "routes_private_nat"
  }
}
