resource "aws_efs_file_system" "efs" {
  creation_token   = "efs"
  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"
  encrypted        = "true"
  tags = {
    Name = "${var.name_efs}_${var.env}"
  }
}
resource "aws_efs_access_point" "test" {
  file_system_id = aws_efs_file_system.efs.id
}