resource "aws_vpc_peering_connection" "peering_connection" { 
  vpc_id      = var.vpc_id
  peer_vpc_id = var.peer_vpc_id
  auto_accept = var.auto_accept
  
  tags = {
    Name = "${var.name_vpc_peering}_${var.environment}"
  }
}



