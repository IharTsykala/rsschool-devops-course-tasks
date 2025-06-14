output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
}

output "k8s_master_public_ip" {
  value       = aws_instance.k8s_instance.public_ip
  description = "Public IP of the k3s master node"
}

output "ssh_command" {
  value       = "ssh -i ./terraform/key_pair.pem ec2-user@${aws_instance.k8s_instance.public_ip}"
  description = "Command to SSH into the k3s master node"
}
