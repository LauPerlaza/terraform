output "vpc_id" {
  value = aws_vpc.vpc_test.id
}
output "subnet_id_sub_public1" {
  value = aws_subnet.sub_public1.id
}
output "subnet_id_sub_public2" {
  value = aws_subnet.sub_public2.id
}
output "subnet_id_sub_private1" {
  value = aws_subnet.sub_private1.id
}
output "subnet_id_sub_private2" {
  value = aws_subnet.sub_private2.id
}