# ---------- VPC ----------

data "aws_vpc" "lab" {
  filter {
    name   = "tag:Name"
    values = ["Lab5-6"]
  }
}

# ---------- Public subnets (for bastion placement) ----------

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.lab.id]
  }
  filter {
    name   = "tag:Name"
    values = ["*Public*"]
  }
}

# ---------- SSM parameters created by Student A ----------

data "aws_ssm_parameter" "db_host" {
  name = "/lab6/db/host"
}

data "aws_ssm_parameter" "db_port" {
  name = "/lab6/db/port"
}

data "aws_ssm_parameter" "db_name" {
  name = "/lab6/db/name"
}

data "aws_ssm_parameter" "db_username" {
  name = "/lab6/db/username"
}

data "aws_ssm_parameter" "db_password" {
  name            = "/lab6/db/password"
  with_decryption = true
}

# ---------- Amazon Linux 2 AMI ----------

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}
