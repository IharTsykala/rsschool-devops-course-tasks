resource "aws_instance" "jenkins_instance" {
  ami           = var.jenkins_ami
  instance_type = "t3.small"
  subnet_id     = aws_subnet.public_subnet_1.id
  key_name      = var.key_pair_name

  security_groups = [aws_security_group.jenkins_security_group.id]

  user_data = file("scripts/install_jenkins.sh")

  tags = {
    Name = "Jenkins Server"
  }
}
