# ---------- VPC ----------

data "aws_vpc" "lab" {
  filter {
    name   = "tag:Name"
    values = ["Lab5-6"]
  }
}

# ---------- Existing private subnets ----------

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.lab.id]
  }
  filter {
    name   = "tag:Name"
    values = ["*Private*"]
  }
}

# ---------- Second private subnet (RDS needs 2 AZs) ----------

resource "aws_subnet" "private_b" {
  vpc_id            = data.aws_vpc.lab.id
  cidr_block        = cidrsubnet(data.aws_vpc.lab.cidr_block, 8, 12)
  availability_zone = "${var.aws_region}b"

  tags = {
    Name = "student_${var.student_X}_${var.student_Y}_Private_b"
  }
}
