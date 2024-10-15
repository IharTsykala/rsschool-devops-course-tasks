resource "aws_security_group" "security_group_public_from_bastion" {
  vpc_id = aws_vpc.main.id

  ingress {
    description = "Allow SSH from all"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "security_group_public_from_bastion"
  }
}
