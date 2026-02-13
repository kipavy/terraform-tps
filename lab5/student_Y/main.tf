# ---------- Data Sources ----------

data "aws_subnet" "private" {
  filter {
    name   = "tag:Name"
    values = ["student_${var.student_X}_${var.student_Y}_Private"]
  }
}

data "aws_security_group" "internal" {
  filter {
    name   = "tag:Name"
    values = ["student_${var.student_X}_${var.student_Y}_internal"]
  }
}

data "aws_lb_target_group" "nginx" {
  name = "st-${var.student_X}-${var.student_Y}-nginx"
}

data "aws_lb_target_group" "tomcat" {
  name = "st-${var.student_X}-${var.student_Y}-tomcat"
}

data "aws_ami" "nginx" {
  most_recent = true
  owners      = ["979382823631"]

  filter {
    name   = "name"
    values = ["bitnami-nginx-*"]
  }
}

data "aws_ami" "tomcat" {
  most_recent = true
  owners      = ["979382823631"]

  filter {
    name   = "name"
    values = ["bitnami-tomcat-*"]
  }
}

# ---------- ASG Modules ----------

module "nginx" {
  source = "./modules/asg"

  ami_id            = data.aws_ami.nginx.id
  min_size          = 2
  max_size          = 2
  subnet_ids        = [data.aws_subnet.private.id]
  security_group_id = data.aws_security_group.internal.id
  target_group_arn  = data.aws_lb_target_group.nginx.arn
  name_prefix       = "st-${var.student_X}-${var.student_Y}-nginx"
}

module "tomcat" {
  source = "./modules/asg"

  ami_id            = data.aws_ami.tomcat.id
  min_size          = 2
  max_size          = 2
  subnet_ids        = [data.aws_subnet.private.id]
  security_group_id = data.aws_security_group.internal.id
  target_group_arn  = data.aws_lb_target_group.tomcat.arn
  name_prefix       = "st-${var.student_X}-${var.student_Y}-tomcat"
}

# ---------- Outputs ----------

output "nginx_asg_name" {
  value = module.nginx.asg_name
}

output "tomcat_asg_name" {
  value = module.tomcat.asg_name
}
