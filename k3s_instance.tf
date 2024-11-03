resource "aws_instance" "k3s_instance" {
  ami           = var.bastion_ami
  instance_type = var.bastion_instance_type
  subnet_id     = aws_subnet.public_subnet_1.id
  key_name      = var.key_pair_name

  security_groups = [
    aws_security_group.k3s_security_group.id,
  ]

  user_data = <<-EOF
    #!/bin/bash

    sudo amazon-linux-extras enable selinux-ng
    sudo yum clean metadata
    sudo yum install -y selinux-policy-targeted
    sudo yum install -y container-selinux

    PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)

    curl -sfL https://get.k3s.io | sh -s - server --tls-san $${PUBLIC_IP}

    sudo /usr/local/bin/k3s kubectl get nodes
    sudo ln -s /usr/local/bin/k3s /usr/bin/kubectl
  EOF

  tags = {
    Name = "k3s_instance"
  }
}
