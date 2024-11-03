# resource "aws_instance" "nat_instance" {
#   ami           = "ami-0df0e7600ad0913a9"
#   instance_type = "t3.micro"
#   #  subnet_id     = aws_subnet.public_subnet_1.id
#
#   network_interface {
#     network_interface_id = aws_network_interface.nat_eni.id
#     device_index         = 0
#   }
#
#   user_data = <<-EOF
#     #!/bin/bash
#     echo 1 > /proc/sys/net/ipv4/ip_forward
#     iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
#   EOF
#
#   tags = {
#     Name = "nat-instance"
#   }
# }
