variable "aws_region" {
  type = string
}

variable "public_key" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "student_name" {
  type = string
}

variable "asg_min" {
  type = number
}

variable "asg_max" {
  type = number
}
