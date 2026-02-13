resource "aws_launch_template" "this" {
  name_prefix   = var.name_prefix
  image_id      = var.ami_id
  instance_type = var.instance_type

  network_interfaces {
    security_groups = [var.security_group_id]
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = var.name_prefix
    }
  }
}

resource "aws_autoscaling_group" "this" {
  name                = var.name_prefix
  min_size            = var.min_size
  max_size            = var.max_size
  desired_capacity    = var.min_size
  vpc_zone_identifier = var.subnet_ids
  target_group_arns   = [var.target_group_arn]

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }
}
