#   #   # AWS_INSTANCE #    #      #
resource "aws_instance" "instance_peering" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  key_name      = "key_web_server"
  associate_public_ip_address = true

  vpc_security_group_ids = var.sg_ids

  tags = {
    Name        = "${var.name}_${var.environment}"
    Environment = var.environment
    CreatedBy   = "terraform"
  }
}
