
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
resource "aws_security_group" "ebs-sg" {
  depends_on  = [module.vpc]
  name        = "security_group_ec2_ebs"
  description = "aws_security_group_ec2_ebs"
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
    Name         = "ec2_ebs_sg_${var.env}"
  }
}

#   #   # AWS_INSTANCE #    #    #
module "ec2_ebs" {
  depends_on           = [aws_security_group.ebs-sg]
  source               = "../modules/ec2"
  instance_type        = var.env == "develop" ? "t2.micro" : "t3.micro"
  subnet_id            = module.vpc.subnet_id_sub_private1
  sg_ids               = [aws_security_group.ebs-sg.id]
  name                 = "server_ebs"
  environment          = var.env
  iam_instance_profile = null

  tags = {
    Name         = "server_ebs_${var.env}"
  }
}

#   #   # AWS EBS #    #    #
module "ebs_test" {
  source = "../modules/ebs"
  name_ebs = "ebs_test"
  env = var.env
  availability_zone = "us-east-1a"
  encrypted =  true
}

#     #   AWS VOLUME ATTACHMENT   #   #   #
resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = module.ebs_test.ebs_id
  instance_id = module.ec2_ebs.instance_id
}