# ---------- RDS Security Group ----------

resource "aws_security_group" "rds" {
  name        = "student_${var.student_X}_${var.student_Y}_rds"
  description = "Allow PostgreSQL from bastion SG"
  vpc_id      = data.aws_vpc.lab.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "student_${var.student_X}_${var.student_Y}_rds"
  }
}

resource "aws_security_group_rule" "rds_from_bastion" {
  count                    = var.bastion_sg_id != "" ? 1 : 0
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = var.bastion_sg_id
  security_group_id        = aws_security_group.rds.id
}

# ---------- DB Subnet Group ----------

resource "aws_db_subnet_group" "lab" {
  name = "student_${var.student_X}_${var.student_Y}_lab6"
  subnet_ids = concat(
    data.aws_subnets.private.ids,
    [aws_subnet.private_b.id]
  )

  tags = {
    Name = "student_${var.student_X}_${var.student_Y}_lab6"
  }
}

# ---------- RDS PostgreSQL Instance ----------

resource "aws_db_instance" "lab" {
  identifier             = "student-${var.student_X}-${var.student_Y}-lab6"
  engine                 = "postgres"
  engine_version         = "14.7"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.lab.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  skip_final_snapshot    = true
  publicly_accessible    = false

  tags = {
    Name = "student_${var.student_X}_${var.student_Y}_lab6"
  }
}
