# ---------- SSM Parameters (DB credentials) ----------

resource "aws_ssm_parameter" "db_host" {
  name  = "/lab6/db/host"
  type  = "String"
  value = aws_db_instance.lab.address
}

resource "aws_ssm_parameter" "db_port" {
  name  = "/lab6/db/port"
  type  = "String"
  value = tostring(aws_db_instance.lab.port)
}

resource "aws_ssm_parameter" "db_name" {
  name  = "/lab6/db/name"
  type  = "String"
  value = var.db_name
}

resource "aws_ssm_parameter" "db_username" {
  name  = "/lab6/db/username"
  type  = "String"
  value = var.db_username
}

resource "aws_ssm_parameter" "db_password" {
  name  = "/lab6/db/password"
  type  = "SecureString"
  value = var.db_password
}
