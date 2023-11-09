variable "region" {
  type        = string
  description = "Region"
  default     = "us-east-1"
}
variable "env" {
  type    = string
  default = "develop"
}

variable "tags" {
  description = "tags to assign to AWS resources."
  type        = map(string)
  default     = {}
}
