output "vpc_id" {
  value = module.vpc.vpc_id
}

output "subnet_id_sub_private1" {
  value = module.vpc.subnet_id_sub_private1
}

output "subnet_id_sub_public1" {
  value = module.vpc.subnet_id_sub_public1
}

output "ec2_efs_sg_id" {
  value = aws_security_group.ec2_efs_sg.id
}

output "efs_sg_id" {
  value = aws_security_group.efs_sg.id
}

output "efs_id" {
  value = module.efs_test.efs_id
}

output "ec2_efs_id" {
  value = module.ec2_efs.instance_id
}
