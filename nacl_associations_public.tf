#resource "aws_subnet_network_acl_association" "nacl_associations_public_1" {
#  subnet_id      = aws_subnet.public_subnet_1.id
#  network_acl_id = aws_network_acl.public_nacl.id
#}
#
#resource "aws_subnet_network_acl_association" "nacl_associations_public_2" {
#  subnet_id      = aws_subnet.public_subnet_2.id
#  network_acl_id = aws_network_acl.public_nacl.id
#}
