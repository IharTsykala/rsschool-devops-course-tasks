output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
}

output "private_subnet_ids" {
  value = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
}

output "bastion_public_ip" {
  value = aws_instance.bastion_instance.public_ip
}

output "bastion_instance_id" {
  value = aws_instance.bastion_instance.id
}

output "nat_instance_id" {
  value = aws_instance.nat_instance.id
}

output "private_instance_id" {
  value = aws_instance.private_instance_to_nat.id
}

output "k3s_master_public_ip" {
  value       = aws_instance.k3s_instance.public_ip
  description = "Public IP of the k3s master node"
}
