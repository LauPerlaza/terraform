variable "region" {
  type        = string
  description = "Region"
  default     = "us-east-1"
}

variable "environment" {
  type        = string
  description = "Entorno de la infraestructura"
}

variable "vpc_id" {
  type        = string
}

variable "peer_vpc_id" {
  type        = string
}

variable "auto_accept" {
  type        = string
}
