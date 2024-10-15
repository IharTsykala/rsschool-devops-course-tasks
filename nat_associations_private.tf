resource "aws_route_table_association" "nat_associations_private_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.routes_private_nat.id
}

resource "aws_route_table_association" "nat_associations_private_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.routes_private_nat.id
}
