variable "region" {
  type        = string
  description = "Region"
}

variable "environment" {
  type = string
}

variable "ip" {
  type        = string
  description = "ip"
}

variable "cidr_block_vpc" {
  description = "Bloque CIDR de la VPC"
  type        = string
}
variable "cidr_block_subnet_public" {
  type = list(string)
}

variable "cidr_block_subnet_private" {
  type = list(string)
}

variable "name_vpc" {
  type = string
}
