resource "aws_key_pair" "key_pair" {
  key_name   = "admin-key"
  public_key = var.public_key
}

resource "aws_security_group" "ssh_access" {
  name        = "allow-ssh-${var.student_name}"
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

resource "aws_instance" "web_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  key_name               = aws_key_pair.key_pair.key_name
  vpc_security_group_ids = [aws_security_group.ssh_access.id]

  tags = {
    Name = var.instance_name
    Owner = var.student_name
  }
}

output "instance_public_ip" {
  value = aws_instance.web_server.public_ip
}