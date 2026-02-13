output "alb_dns_name" {
  value = aws_lb.this.dns_name
}

output "alb_arn" {
  value = aws_lb.this.arn
}

output "nginx_target_group_arn" {
  value = aws_lb_target_group.nginx.arn
}

output "tomcat_target_group_arn" {
  value = aws_lb_target_group.tomcat.arn
}
