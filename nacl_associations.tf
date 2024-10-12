#resource "aws_subnet_network_acl_association" "public_nacl_assoc_1" {
#  subnet_id      = aws_subnet.public_subnet_1.id
#  network_acl_id = aws_network_acl.public_nacl.id
#}
#
#resource "aws_subnet_network_acl_association" "public_nacl_assoc_2" {
#  subnet_id      = aws_subnet.public_subnet_2.id
#  network_acl_id = aws_network_acl.public_nacl.id
#}
#
#resource "aws_route_table_association" "private_rt_assoc_1" {
#  subnet_id      = aws_subnet.private_subnet_1.id
#  route_table_id = aws_route_table.private_rt.id
#}
#
#resource "aws_route_table_association" "private_rt_assoc_2" {
#  subnet_id      = aws_subnet.private_subnet_2.id
#  route_table_id = aws_route_table.private_rt.id
#}
