#   #   # AWS_VPC #  #   #
module "vpc1" {
  source                    = "../modules/networking"
  region                    = var.region
  environment               = var.env
  name_vpc                  = "vpc1"
  ip                        = "67.73.233.212/32"
  cidr_block_vpc            = "10.20.0.0/16"
  cidr_block_subnet_public  = ["10.20.1.0/24", "10.20.2.0/24"]
  cidr_block_subnet_private = ["10.20.10.0/24", "10.20.20.0/24"]
}

#   #   # AWS_VPC #  #   #
module "vpc2" {
  source                    = "../modules/networking"
  region                    = var.region
  environment               = var.env
  name_vpc                  = "vpc2"
  ip                        = "67.73.233.212/32"
  cidr_block_vpc            = "192.168.0.0/16"
  cidr_block_subnet_public  = ["192.168.10.0/24", "192.168.20.0/24"]
  cidr_block_subnet_private = ["192.168.30.0/24", "192.168.40.0/24"]
}

#   #   # aws_vpc_peering_connection #  #   #
resource "aws_vpc_peering_connection" "peering_connection" {
  depends_on  = [module.vpc1, module.vpc2]
  vpc_id      = module.vpc1.vpc_id
  peer_vpc_id = module.vpc2.vpc_id
  auto_accept = true
}

#   #   # AWS ROUTE TABLE #  #   #
resource "aws_route_table" "route_table_vpc1" {
  vpc_id = module.vpc1.vpc_id

  tags = {
    Name         = "route_table_vpc1_${var.env}"
  }
}

#   #   # AWS ROUTE TABLE #  #   #
resource "aws_route_table" "route_table_vpc2" {
  vpc_id = module.vpc2.vpc_id

  tags = {
    Name         = "route_table_vpc2_${var.env}"
  }
}

#   #   # AWS ROUTE  #  #   #
resource "aws_route" "route_vpc1" {
  depends_on                = [aws_route_table.route_table_vpc1]
  route_table_id            = aws_route_table.route_table_vpc2.id
  destination_cidr_block    = "10.20.0.0/16"
  vpc_peering_connection_id = aws_vpc_peering_connection.peering_connection.id
}

#   #   # AWS ROUTE  #  #   #
resource "aws_route" "route_vpc2" {
  depends_on                = [aws_route_table.route_table_vpc2]
  route_table_id            = aws_route_table.route_table_vpc1.id
  destination_cidr_block    = "192.168.0.0/16"
  vpc_peering_connection_id = aws_vpc_peering_connection.peering_connection.id
}

#   #   # AWS SECURITY GROUP #  #   #
resource "aws_security_group" "sec_group_vpc1" {
  depends_on  = [module.vpc1]
  name        = "security_group_ec2_peering"
  description = "aws_security_group_ec2"
  vpc_id      = module.vpc1.vpc_id

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
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
  tags = {
    Name         = "sec_group_vpc1_${var.env}"
  }
}
#   #   # AWS_INSTANCE #   #   #
module "ec2_peering_1" {
  depends_on           = [aws_security_group.sec_group_vpc1]
  source               = "../modules/ec2"
  instance_type        = var.env == "develop" ? "t2.micro" : "t3.micro"
  subnet_id            = module.vpc1.subnet_id_sub_public1
  sg_ids               = [aws_security_group.sec_group_vpc1.id]
  name                 = "server_peering_1"
  environment          = var.env
  iam_instance_profile = null

  tags = {
    Name               = "server_peering_1_${var.env}"
  }
}

#   #   # AWS SECURITY GROUP #  #   #
resource "aws_security_group" "sec_group_vpc2" {
  depends_on  = [module.vpc2]
  name        = "security_group_ec2_peering"
  description = "aws_security_group_ec2"
  vpc_id      = module.vpc2.vpc_id

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
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
  tags = {
    Name         = "sec_group_vpc2_${var.env}"
  }
}

#   #   # AWS_INSTANCE #    #    #
module "ec2_peering_2" {
  depends_on           = [aws_security_group.sec_group_vpc2]
  source               = "../modules/ec2"
  instance_type        = var.env == "develop" ? "t2.micro" : "t3.micro"
  subnet_id            = module.vpc2.subnet_id_sub_private1
  sg_ids               = [aws_security_group.sec_group_vpc2.id]
  name                 = "server_peering_2"
  environment          = var.env
  iam_instance_profile = null

  tags = {
    Name         = "server_peering_2_${var.env}"
  }
}