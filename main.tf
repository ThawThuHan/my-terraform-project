provider "aws" {
  profile = "default"
  region = "ap-southeast-1"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = var.vpc_cidr_block

  azs             = [var.availability_zone]
  #private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = [var.subnet_cidr_block]
  public_subnet_tags = {
    Name = "${var.env_prefix}-subnet-1"
  }

  # enable_nat_gateway = true
  # enable_vpn_gateway = true

  tags = {
    Name = "${var.env_prefix}-vpc"
  }
}

# resource "aws_route_table" "myapp-route-table" {
#   vpc_id = aws_vpc.myapp-vpc.id
#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.myapp-igw.id
#   }
#   tags = {
#     Name = "${var.env_prefix}-rtb"
#   }
# }

# resource "aws_route_table_association" "route-subnet-association" {
#   subnet_id = aws_subnet.myapp-subnet-1.id
#   route_table_id = aws_route_table.myapp-route-table.id
# }

module "webserver" {
  source = "./modules/webserver"
  subnet_id = module.vpc.public_subnets[0]
  instance_type = var.instance_type
  env_prefix = var.env_prefix
  public_key_path = var.public_key_path
  vpc_id = module.vpc.vpc_id
}