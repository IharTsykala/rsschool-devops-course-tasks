resource "aws_instance" "k3s_instance" {
  ami           = var.bastion_ami
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.public_subnet_1.id
  key_name      = var.key_pair_name

  security_groups = [
    aws_security_group.security_group_public_from_bastion.id,
  ]

  user_data = <<-EOF
    #!/bin/bash
    curl -sfL https://get.k3s.io | sh -
  EOF

  tags = {
    Name = "k3s_instance"
  }
}
