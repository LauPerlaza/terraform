#   #   # AWS NETWORKING FOR EFS  #  #   #
module "vpc" {
  source                    = "../modules/networking"
  region                    = var.region
  environment               = var.env
  name_vpc                  = "vpc_tf"
  ip                        = "190.5.196.109/32"
  cidr_block_vpc            = "10.50.0.0/16"
  cidr_block_subnet_public  = ["10.50.1.0/24", "10.50.2.0/24"]
  cidr_block_subnet_private = ["10.50.3.0/24", "10.50.4.0/24"]
}

#   #   # AWS SECURITY GROUP FOR EC2 EFS #  #   #
resource "aws_security_group" "ec2_efs_sg" {
  depends_on = [module.vpc]
  name        = "security_group_ec2_efs"
  description = "security_group_ec2_efs"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["190.5.196.109/32"]
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
    Name = "security_group_ec2_efs_${var.env}"
  }
}

#   #   # AWS SECURITY GROUP FOR EFS    #  #   #
resource "aws_security_group" "efs_sg" {
  depends_on = [module.vpc, aws_security_group.ec2_efs_sg]
  name        = "efs-sg"
  description = "efs traffic from ec2"
  vpc_id      = module.vpc.vpc_id

  ingress {
    security_groups = [aws_security_group.ec2_efs_sg.id]
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
  }
  egress {
    security_groups = [aws_security_group.ec2_efs_sg.id]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name         = "efs_sg_${var.env}"
  }
}

#   #   #   AWS EFS FILE SYSTEM #    #    #
module "efs_test" {
  source = "../modules/efs"
  name_efs = "efs_test"
  env = var.env
}

#   #   #   AWS EFS MOUNT TARGET  #   #   #
resource "aws_efs_mount_target" "efs-mt" {
  depends_on = [module.efs_test, aws_security_group.efs_sg]
  file_system_id  = module.efs_test.efs_id
  subnet_id       = module.vpc.subnet_id_sub_private1
  security_groups = [aws_security_group.efs_sg.id]
}


#   #   # AWS INSTANCE FOR EFS #    #    #
module "ec2_efs" {
  depends_on           = [module.efs_test, aws_efs_mount_target.efs-mt, aws_security_group.efs_sg]
  source               = "../modules/ec2"
  instance_type        = var.env == "develop" ? "t2.micro" : "t3.micro"
  subnet_id            = module.vpc.subnet_id_sub_public1
  sg_ids               = [aws_security_group.ec2_efs_sg.id]
  name                 = "ec2-for-efs-ebs"
  environment          = var.env
  iam_instance_profile = null

  tags = {
    Name = "server_efs_${var.env}"
  }
}
