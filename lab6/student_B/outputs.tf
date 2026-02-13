output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}

output "ssh_command" {
  value = "ssh -i <your-key>.pem ec2-user@${aws_instance.bastion.public_ip}"
}

output "bastion_sg_id" {
  value = aws_security_group.bastion.id
}
