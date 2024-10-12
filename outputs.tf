output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
}

output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}

output "bastion_instance_id" {
  value = aws_instance.bastion.id
}
