output "vpc1_id" {
  value = module.vpc1.vpc_id
}

output "subnet_id_public_vpc1_1" {
  value = module.vpc1.subnet_id_sub_public1
}

output "subnet_id_public_vpc1_2" {
  value = module.vpc1.subnet_id_sub_public2
}

output "subnet_id_private_vpc1_1" {
  value = module.vpc1.subnet_id_sub_private1
}

output "subnet_id_private_vpc1_2" {
  value = module.vpc1.subnet_id_sub_private2
}

output "vpc2_id" {
  value = module.vpc2.vpc_id
}

output "subnet_id_public_vpc2_1" {
  value = module.vpc2.subnet_id_sub_public1
}

output "subnet_id_public_vpc2_2" {
  value = module.vpc2.subnet_id_sub_public2
}

output "subnet_id_private_vpc2_1" {
  value = module.vpc2.subnet_id_sub_private1
}

output "subnet_id_private_vpc2_2" {
  value = module.vpc2.subnet_id_sub_private2
}

output "vpc_peering_connection_id" {
  value = aws_vpc_peering_connection.peering_connection.id
}

output "route_table_vpc1_id" {
  value = aws_route_table.route_table_vpc1.id
}

output "route_table_vpc2_id" {
  value = aws_route_table.route_table_vpc2.id
}

output "security_group_vpc1_id" {
  value = aws_security_group.sec_group_vpc1.id
}

output "security_group_vpc2_id" {
  value = aws_security_group.sec_group_vpc2.id
}

output "ec2_peering_1_id" {
  value = module.ec2_peering_1.instance_id
}

output "ec2_peering_2_id" {
  value = module.ec2_peering_2.instance_id
}
