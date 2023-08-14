variable "vpc_id" {
  description = "VPC ID"
  type = string
}

variable "subnet_cidr_block" {
  description = "subnet cidr block"
  type = string
}

variable "default_route_table_id" {
  description = "Default Route Table ID"
  type = string
}

variable "env_prefix" {
  type = string
}

variable "availability_zone" {
  type = string
}