# ---------- Data Sources ----------

data "aws_vpc" "lab" {
  filter {
    name   = "tag:Name"
    values = ["Lab5-6"]
  }
}

data "aws_internet_gateway" "lab" {
  filter {
    name   = "attachment.vpc-id"
    values = [data.aws_vpc.lab.id]
  }
}

# ---------- Subnets ----------

resource "aws_subnet" "private" {
  vpc_id            = data.aws_vpc.lab.id
  cidr_block        = cidrsubnet(data.aws_vpc.lab.cidr_block, 8, 11)
  availability_zone = "${var.aws_region}a"

  tags = {
    Name = "student_${var.student_X}_${var.student_Y}_Private"
  }
}

resource "aws_subnet" "public_a" {
  vpc_id                  = data.aws_vpc.lab.id
  cidr_block              = cidrsubnet(data.aws_vpc.lab.cidr_block, 8, 111)
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true

  tags = {
    Name = "student_${var.student_X}_${var.student_Y}_Public_a"
  }
}

resource "aws_subnet" "public_b" {
  vpc_id                  = data.aws_vpc.lab.id
  cidr_block              = cidrsubnet(data.aws_vpc.lab.cidr_block, 8, 113)
  availability_zone       = "${var.aws_region}b"
  map_public_ip_on_launch = true

  tags = {
    Name = "student_${var.student_X}_${var.student_Y}_Public_b"
  }
}

# ---------- Route Table (public subnets) ----------

resource "aws_route_table" "public" {
  vpc_id = data.aws_vpc.lab.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = data.aws_internet_gateway.lab.id
  }

  tags = {
    Name = "student_${var.student_X}_${var.student_Y}_Public_RT"
  }
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public.id
}

# ---------- Security Groups ----------

resource "aws_security_group" "public" {
  name        = "student_${var.student_X}_${var.student_Y}_public"
  description = "Allow HTTP/HTTPS from internet"
  vpc_id      = data.aws_vpc.lab.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "student_${var.student_X}_${var.student_Y}_public"
  }
}

resource "aws_security_group" "internal" {
  name        = "student_${var.student_X}_${var.student_Y}_internal"
  description = "Allow HTTP/HTTPS from public SG only"
  vpc_id      = data.aws_vpc.lab.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.public.id]
  }

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.public.id]
  }

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.public.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "student_${var.student_X}_${var.student_Y}_internal"
  }
}

# ---------- ALB Module ----------

module "alb" {
  source = "./modules/alb"

  vpc_id            = data.aws_vpc.lab.id
  public_subnet_ids = [aws_subnet.public_a.id, aws_subnet.public_b.id]
  security_group_id = aws_security_group.public.id
  name_prefix       = "st-${var.student_X}-${var.student_Y}"
}

# ---------- Outputs ----------

output "vpc_id" {
  value = data.aws_vpc.lab.id
}

output "private_subnet_id" {
  value = aws_subnet.private.id
}

output "public_subnet_a_id" {
  value = aws_subnet.public_a.id
}

output "public_subnet_b_id" {
  value = aws_subnet.public_b.id
}

output "public_sg_id" {
  value = aws_security_group.public.id
}

output "internal_sg_id" {
  value = aws_security_group.internal.id
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "alb_arn" {
  value = module.alb.alb_arn
}

output "nginx_target_group_arn" {
  value = module.alb.nginx_target_group_arn
}

output "tomcat_target_group_arn" {
  value = module.alb.tomcat_target_group_arn
}
