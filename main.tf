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

resource "aws_subnet" "myapp-subnet-1" {
  vpc_id = aws_vpc.myapp-vpc.id
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
  vpc_id = aws_vpc.myapp-vpc.id 
}

#using existing route table that is created by default
resource "aws_default_route_table" "main-rtb" {
  default_route_table_id = aws_vpc.myapp-vpc.default_route_table_id

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
  route_table_id = aws_default_route_table.main-rtb.id
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

resource "aws_security_group" "myapp-sg" {
  name = "myapp-sg"
  vpc_id = aws_vpc.myapp-vpc.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 22
    to_port = 22
    protocol = "tcp"
  }
  
  ingress { 
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env_prefix}-sg"
  }
}

data "aws_ami" "latest-amazon-linux-image" {
  most_recent = true
  owners = [ "amazon" ]
  filter {
    name = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_key_pair" "ssh-key" {
  key_name = "myapp-key"
  public_key = "${file(var.public_key_path)}"
}

resource "aws_instance" "myapp" {
  ami		= data.aws_ami.latest-amazon-linux-image.id
  instance_type	= var.instance_type
  subnet_id = aws_subnet.myapp-subnet-1.id
  vpc_security_group_ids = [ aws_security_group.myapp-sg.id ]
  key_name = aws_key_pair.ssh-key.key_name
  tags = {
    Name = "${var.env_prefix}-myapp-server"
  }
}