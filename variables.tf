variable "vpc_cidr_block" {
  description = "vpc cidr block"
  type = string
}

variable "subnet_cidr_blocks" {
  description = "subnet cidr blocks"
  type = list(string)
}
