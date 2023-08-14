variable "env_prefix" {
  description = "Environment Prefix"
  default = "dev"
}

variable "availability_zone" {
  description = "Availability Zone for Subnet"
  type = string
}

variable "vpc_cidr_block" {
  description = "vpc cidr block"
  type = string
}

variable "subnet_cidr_block" {
  description = "subnet cidr block"
  type = string
}

variable "instance_type" {
  type = string
}

variable "public_key_path" {
  type = string
}

variable "private_key_path" {
  type = string
}