output "rds_security_group_id" {
  value = aws_security_group.rds.id
}

output "rds_endpoint" {
  value = aws_db_instance.lab.endpoint
}

output "rds_address" {
  value = aws_db_instance.lab.address
}

output "rds_port" {
  value = aws_db_instance.lab.port
}

output "db_name" {
  value = var.db_name
}
