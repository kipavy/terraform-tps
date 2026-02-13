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

variable "db_name" {
  type    = string
  default = "labdb"
}

variable "db_username" {
  type    = string
  default = "labadmin"
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "bastion_sg_id" {
  type        = string
  default     = ""
  description = "Student B's bastion security group ID (empty for initial deploy)"
}
