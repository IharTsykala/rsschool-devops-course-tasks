resource "aws_instance" "k3s_instance" {
  ami           = var.bastion_ami
  instance_type = "t3.small"
  subnet_id     = aws_subnet.public_subnet_1.id
  key_name      = var.key_pair_name

  security_groups = [
    aws_security_group.k3s_security_group.id,
  ]

  user_data = <<-EOF
              #!/bin/bash

              # K3s installation script with required dependencies
              sudo amazon-linux-extras enable selinux-ng
              sudo yum clean metadata
              sudo yum install -y selinux-policy-targeted container-selinux

              curl -sfL https://get.k3s.io | sh -
              sudo ln -s /usr/local/bin/k3s /usr/bin/kubectl
              EOF

  tags = {
    Name = "k3s_instance"
  }
}
