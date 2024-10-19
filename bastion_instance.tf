resource "aws_instance" "bastion_instance" {
  ami                         = "ami-0df0e7600ad0913a9"
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public_subnet_1.id
  associate_public_ip_address = true

  vpc_security_group_ids = [
    aws_security_group.security_group_public_from_bastion.id,
  ]

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y amazon-ssm-agent
  EOF

  tags = {
    Name = "bastion-host"
  }
}
