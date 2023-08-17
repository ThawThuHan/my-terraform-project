provider "aws" {
  profile = "default"
  region = "ap-southeast-1"
}

resource "aws_vpc" "myapp-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "${var.env_prefix}-vpc" 
  }
}

module "myapp-subnet" {
  source = "./modules/subnet"
  subnet_cidr_block = var.subnet_cidr_block
  availability_zone = var.availability_zone
  env_prefix = var.env_prefix
  vpc_id = aws_vpc.myapp-vpc.id
  default_route_table_id = aws_vpc.myapp-vpc.default_route_table_id
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
  subnet_id = module.myapp-subnet.subnet.id
  instance_type = var.instance_type
  env_prefix = var.env_prefix
  public_key_path = var.public_key_path
  vpc_id = aws_vpc.myapp-vpc.id
}