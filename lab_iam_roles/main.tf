#   #   # AWS INSTANCE PROFILE #    #    #
resource "aws_iam_instance_profile" "test_profile" {
  name = "test_profile"
  role = module.iam_role.iam_role_name
}

#   #   # IAM ROLE #    #    #
module "iam_role" {
  source      = "../modules/iam_role"
  role_name   = "server_role"
  policy_name = "ec2_policy"
}

#   #   # AWS_VPC #  #   #
module "vpc" {
  source                    = "../modules/networking"
  region                    = var.region
  environment               = var.env
  name_vpc                  = "vpc"
  ip                        = "67.73.233.212/32"
  cidr_block_vpc            = "192.168.0.0/16"
  cidr_block_subnet_public  = ["192.168.10.0/24", "192.168.20.0/24"]
  cidr_block_subnet_private = ["192.168.30.0/24", "192.168.40.0/24"]
}

#   #   # AWS SECURITY GROUP #  #   #
resource "aws_security_group" "iam-sg" {
  depends_on  = [module.vpc]
  name        = "security_group_ec2_iam_"
  description = "aws_security_group_ec2_iam"
  vpc_id      = module.vpc.vpc_id

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
    Name         = "ec2_iam_sg_${var.env}"
  }
}

#   #   # AWS INSTANCE FOR IAM ROLE #    #    #
module "ec2_instance" {
  depends_on           = [module.iam_role, aws_security_group.iam-sg]
  source               = "../modules/ec2"
  instance_type        = var.env == "develop" ? "t2.micro" : "t3.micro"
  subnet_id            = module.vpc.subnet_id_sub_public1
  sg_ids               = [aws_security_group.iam-sg.id]
  name                 = "server_iam_role"
  environment          = var.env
  iam_instance_profile = aws_iam_instance_profile.test_profile.name

  tags = {
    Name = "server_iam_role_${var.env}"
  }
}
