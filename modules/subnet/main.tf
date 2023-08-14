resource "aws_subnet" "myapp-subnet-1" {
  vpc_id = var.vpc_id
  cidr_block = var.subnet_cidr_block
  availability_zone = var.availability_zone
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.env_prefix}-private-subnet-1"
  }
}

# data "aws_vpc" "default-vpc" {
#   default = true
# }

resource "aws_internet_gateway" "myapp-igw" {
  vpc_id = var.vpc_id
}

#using existing route table that is created by default
resource "aws_default_route_table" "main-rtb" {
  default_route_table_id = var.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myapp-igw.id
  }
  tags = {
    Name = "${var.env_prefix}-main-rtb"
  }
}

resource "aws_route_table_association" "route-subnet-association" {
  subnet_id = aws_subnet.myapp-subnet-1.id
  route_table_id = var.default_route_table_id
}