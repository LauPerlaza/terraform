#   #   # AWS_INSTANCE #    #      #
resource "aws_instance" "instance_test" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  key_name      = "key_web_server"
  associate_public_ip_address = true
  iam_instance_profile = var.iam_instance_profile == "" ? null : var.iam_instance_profile
  vpc_security_group_ids = var.sg_ids
}