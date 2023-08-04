provider "aws" {
  profile = "default"
  region = "ap-southeast-1"
}

# resource "aws_instance" "web" {
#   ami		= "ami-0df7a207adb9748c7"
#   instance_type	= "t2.micro"
# }

variable "vpc_cidr_block" {
  description = "vpc cidr block"
  type = string
}

variable "subnet_cidr_blocks" {
  description = "subnet cidr blocks"
  type = list(string)
}

resource "aws_vpc" "development-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "development" 
  }
}

resource "aws_subnet" "private-subnet-1" {
  vpc_id = aws_vpc.development-vpc.id
  cidr_block = var.subnet_cidr_blocks[1]
  availability_zone = "ap-southeast-1a"
  tags = {
    Name = "private-subnet-1"
  }
}

data "aws_vpc" "default-vpc" {
  default = true
}

resource "aws_subnet" "default-private-subnet" {
  vpc_id = data.aws_vpc.default-vpc.id
  cidr_block = "172.31.64.0/20"
  availability_zone = "ap-southeast-1b"
  map_public_ip_on_launch = true
}

output "development-vpc-id" {
  value = aws_vpc.development-vpc.id
}

output "private-subnet-1-id" {
  value = aws_subnet.private-subnet-1.id
}