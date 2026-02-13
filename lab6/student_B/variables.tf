variable "aws_region" {
  type    = string
  default = "eu-west-3"
}

variable "student_X" {
  type = string
}

variable "student_Y" {
  type = string
}

variable "my_ip" {
  type        = string
  description = "Your public IP in CIDR notation (e.g. 203.0.113.10/32)"
}

variable "key_name" {
  type        = string
  description = "EC2 key pair name for SSH access"
}
