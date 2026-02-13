# ---------- IAM Role (EC2 trust policy) ----------

resource "aws_iam_role" "bastion" {
  name = "student_${var.student_X}_${var.student_Y}_bastion_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "student_${var.student_X}_${var.student_Y}_bastion_role"
  }
}

# ---------- IAM Policy (read SSM /lab6/db/* + KMS decrypt) ----------

resource "aws_iam_role_policy" "bastion_ssm" {
  name = "student_${var.student_X}_${var.student_Y}_bastion_ssm"
  role = aws_iam_role.bastion.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssm:GetParameter",
          "ssm:GetParameters"
        ]
        Resource = "arn:aws:ssm:${var.aws_region}:*:parameter/lab6/db/*"
      },
      {
        Effect   = "Allow"
        Action   = "kms:Decrypt"
        Resource = "*"
      }
    ]
  })
}

# ---------- Instance Profile ----------

resource "aws_iam_instance_profile" "bastion" {
  name = "student_${var.student_X}_${var.student_Y}_bastion_profile"
  role = aws_iam_role.bastion.name
}
