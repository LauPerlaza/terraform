resource "aws_ebs_volume" "ebs" {
  availability_zone = var.availability_zone
  size              = 40
  encrypted = var.encrypted 
  type = "standard"

  tags = {
    Name = "${var.name_ebs}_${var.env}"
  }
}