resource "aws_vpc_peering_connection" "peering_connection" { 
  vpc_id      = var.vpc_id
  peer_vpc_id = var.peer_vpc_id
  auto_accept = var.auto_accept
  tags = var.tags
}



