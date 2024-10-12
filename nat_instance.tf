resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

resource "aws_instance" "nat_instance" {
  ami                         = "ami-0c55b159cbfafe1f0"
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public_subnet_1.id
  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    echo 1 > /proc/sys/net/ipv4/ip_forward
    iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
  EOF

  tags = {
    Name = "nat-instance"
  }
}
