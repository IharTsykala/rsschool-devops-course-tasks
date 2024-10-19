#resource "aws_subnet_network_acl_association" "nacl_associations_private_1" {
#  subnet_id      = aws_subnet.private_subnet_1.id
#  network_acl_id = aws_network_acl.network_acls_private.id
#}
#
#resource "aws_subnet_network_acl_association" "nacl_associations_private_2" {
#  subnet_id      = aws_subnet.private_subnet_2.id
#  network_acl_id = aws_network_acl.network_acls_private.id
#}
