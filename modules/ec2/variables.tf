variable "ami" {
  default     = "ami-03ed7c3356c95b253"
  type        = string
  description = "ami_ec2_test_2"
}
variable "instance_type" {
  type        = string
  description = "instance_type"
}
variable "subnet_id" {
  type        = string
  description = "subnet_id_public"
}
variable "sg_ids" {
  type = list(any)
}
variable "name" {
  type = string
}
variable "environment" {
  type = string
}

variable "iam_instance_profile" {
  description = "name of the IAM role to associate with the EC2 instance"
  type        = string
}

variable "tags" {
  description = "tags to assign to AWS resources."
  type        = map(string)
  default     = {}
}

