resource "aws_instance" "bastion" {
  ami                         = "ami-0c55b159cbfafe1f0"
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public_subnet_1.id
  associate_public_ip_address = true

  security_groups = [
    aws_security_group.bastion_sg.name,
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
