variable "role_name" {
  description = "name of the IAM role"
  type        = string
}

variable "policy_name" {
  description = "name of the IAM policy"
  type        = string
}
variable "tags" {
  description = "tags to assign to AWS resources."
  type        = map(string)
  default     = {}
}
