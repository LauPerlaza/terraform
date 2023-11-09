#   #   # AWS_VPC #  #   #
resource "aws_vpc" "vpc_test" {
  cidr_block           = var.cidr_block_vpc
  enable_dns_hostnames = true
  enable_dns_support   = true

   tags = {
    Name        = "${var.name_vpc}_${var.environment}"
    Environment = var.environment
  }
}

#   #   # AWS_SUBNETS_PUBLIC #  #   #
resource "aws_subnet" "sub_public1" {
  vpc_id            = aws_vpc.vpc_test.id
  cidr_block        = var.cidr_block_subnet_public[0]
  availability_zone = "${var.region}a"
  
  tags = {
    Name = "sub_pub1_${var.environment}"
  }
}

resource "aws_subnet" "sub_public2" {
  vpc_id            = aws_vpc.vpc_test.id
  cidr_block        = var.cidr_block_subnet_public[1]
  availability_zone = "${var.region}b"
 
  tags = {
    Name = "sub_pub2_${var.environment}"
    billing_mode = "laura_learning"
  }
}

#   #   # AWS_SUBNETS_PRIVATE #  #   #
resource "aws_subnet" "sub_private1" {
  vpc_id            = aws_vpc.vpc_test.id
  cidr_block        = var.cidr_block_subnet_private[0]
  availability_zone = "${var.region}a"
  
  tags = {
    Name = "sub_priv1_${var.environment}"
    billing_mode = "laura_learning"
  }
}

resource "aws_subnet" "sub_private2" {
  vpc_id            = aws_vpc.vpc_test.id
  cidr_block        = var.cidr_block_subnet_private[1]
  availability_zone = "${var.region}b"
  
  tags = {
    Name = "sub_priv2_${var.environment}"
    billing_mode = "laura_learning"
  }
}

#   #   # AWS INTERNET GATEWAY #  #   #
resource "aws_internet_gateway" "igw_test" {
  vpc_id = aws_vpc.vpc_test.id
  
  tags = {
    Name = "internet_gateway_test_${var.environment}"
    billing_mode = "laura_learning"
  }
}
#   #   # AWS ROUTE TABLE #  #   #
resource "aws_route_table" "route_table_test" {
  vpc_id = aws_vpc.vpc_test.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_test.id
  }
  
  tags = {
    Name = "route_table_test_${var.environment}"
    billing_mode = "laura_learning"
  }
}
#   #   # AWS ROUTE TABLE ASSOCIATION  #  #   #
resource "aws_route_table_association" "route_table_test" {
  subnet_id      = aws_subnet.sub_public1.id
  route_table_id = aws_route_table.route_table_test.id
}

resource "aws_route_table_association" "route_table_test1" {
  subnet_id      = aws_subnet.sub_public2.id
  route_table_id = aws_route_table.route_table_test.id
}

#   #   # AWS SECURITY GROUP #  #   #
resource "aws_security_group" "security_test" {
  name        = "security_group_test"
  description = "security_group_test"
  vpc_id      = aws_vpc.vpc_test.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.ip}"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
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
    Name = "security_gruop_test_${var.environment}"
    billing_mode = "laura_learning"
  }
}