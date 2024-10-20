# resource "aws_instance" "private_instance_to_nat" {
#   ami           = "ami-0df0e7600ad0913a9"
#   instance_type = "t3.micro"
#   subnet_id     = aws_subnet.private_subnet_1.id
#
#   #  vpc_security_group_ids = [
#   #    aws_security_group.security_group_private_to_nat.id,
#   #  ]
#
#   tags = {
#     Name = "private_instance_to_nat"
#   }
# }
