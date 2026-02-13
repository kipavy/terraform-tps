# ---------- Bastion Security Group ----------

resource "aws_security_group" "bastion" {
  name        = "student_${var.student_X}_${var.student_Y}_bastion"
  description = "Allow SSH from my IP"
  vpc_id      = data.aws_vpc.lab.id

  ingress {
    description = "SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "student_${var.student_X}_${var.student_Y}_bastion"
  }
}

# ---------- Bastion EC2 Instance ----------

resource "aws_instance" "bastion" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = "t3.micro"
  subnet_id              = tolist(data.aws_subnets.public.ids)[0]
  vpc_security_group_ids = [aws_security_group.bastion.id]
  key_name               = var.key_name
  iam_instance_profile   = aws_iam_instance_profile.bastion.name

  user_data = <<-EOF
    #!/bin/bash
    set -e

    # Install PostgreSQL 14 client
    amazon-linux-extras enable postgresql14
    yum install -y postgresql14

    # Fetch credentials from SSM Parameter Store
    REGION=$(curl -s http://169.254.169.254/latest/meta-data/placement/region)
    DB_HOST=$(aws ssm get-parameter --name "/lab6/db/host" --region $REGION --query "Parameter.Value" --output text)
    DB_PORT=$(aws ssm get-parameter --name "/lab6/db/port" --region $REGION --query "Parameter.Value" --output text)
    DB_NAME=$(aws ssm get-parameter --name "/lab6/db/name" --region $REGION --query "Parameter.Value" --output text)
    DB_USER=$(aws ssm get-parameter --name "/lab6/db/username" --region $REGION --query "Parameter.Value" --output text)
    DB_PASS=$(aws ssm get-parameter --name "/lab6/db/password" --region $REGION --with-decryption --query "Parameter.Value" --output text)

    # Create connection script
    cat > /home/ec2-user/connect_db.sh <<'SCRIPT'
#!/bin/bash
REGION=$(curl -s http://169.254.169.254/latest/meta-data/placement/region)
DB_HOST=$(aws ssm get-parameter --name "/lab6/db/host" --region $REGION --query "Parameter.Value" --output text)
DB_PORT=$(aws ssm get-parameter --name "/lab6/db/port" --region $REGION --query "Parameter.Value" --output text)
DB_NAME=$(aws ssm get-parameter --name "/lab6/db/name" --region $REGION --query "Parameter.Value" --output text)
DB_USER=$(aws ssm get-parameter --name "/lab6/db/username" --region $REGION --query "Parameter.Value" --output text)
DB_PASS=$(aws ssm get-parameter --name "/lab6/db/password" --region $REGION --with-decryption --query "Parameter.Value" --output text)
PGPASSWORD=$DB_PASS psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME
SCRIPT
    chmod +x /home/ec2-user/connect_db.sh
    chown ec2-user:ec2-user /home/ec2-user/connect_db.sh
  EOF

  tags = {
    Name = "student_${var.student_X}_${var.student_Y}_bastion"
  }
}
