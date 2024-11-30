resource "aws_instance" "k8s_instance" {
  ami           = var.k8s_master_ami
  instance_type = "t3.small"
  subnet_id     = aws_subnet.public_subnet_1.id
  key_name      = var.key_pair_name

  security_groups = [
    aws_security_group.k8s_security_group.id,
  ]

  iam_instance_profile = aws_iam_instance_profile.K8sProfile.name

  user_data = file("./scripts/install_k8s.sh")

  tags = {
    Name = "k8s_instance"
  }
}
