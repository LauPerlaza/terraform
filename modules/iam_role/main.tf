resource "aws_iam_role" "role_ec2" {
  name = var.role_name 
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "rol_policy" {
  name        = var.policy_name
  description = "Política de solo lectura para VPC"
  tags = var.tags

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "ec2:DescribeVpcs",
        Effect = "Allow",
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "policy_attachment" {
  policy_arn = aws_iam_policy.rol_policy.arn
  role       = aws_iam_role.role_ec2.name
}