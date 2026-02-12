resource "aws_key_pair" "key_pair" {
  key_name   = "admin-key-${var.student_name}-${terraform.workspace}"
  public_key = var.public_key
}

resource "aws_security_group" "ssh_access" {
  name        = "allow-ssh-${var.student_name}-${terraform.workspace}"
  description = "Allow SSH Inbound Traffic for ${var.student_name}"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_subnets" "selected" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_launch_template" "web_server" {
  name_prefix   = "web-${var.student_name}-${terraform.workspace}-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  key_name      = aws_key_pair.key_pair.key_name

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.ssh_access.id]
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name  = "WebServer-${var.student_name}-${terraform.workspace}"
      Owner = var.student_name
    }
  }
}

resource "aws_autoscaling_group" "web_server" {
  name                      = "asg-${var.student_name}-${terraform.workspace}"
  min_size                  = var.asg_min
  max_size                  = var.asg_max
  desired_capacity          = var.asg_min
  vpc_zone_identifier       = [data.aws_subnets.selected.ids[0]]
  wait_for_capacity_timeout = "0"

  launch_template {
    id      = aws_launch_template.web_server.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "WebServer-${var.student_name}-${terraform.workspace}"
    propagate_at_launch = true
  }
}
