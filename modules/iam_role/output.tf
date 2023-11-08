output "iam_role_name" {
  value = aws_iam_role.role_ec2.name
}

output "iam_policy_arn" {
  value = aws_iam_policy.rol_policy.arn
}
