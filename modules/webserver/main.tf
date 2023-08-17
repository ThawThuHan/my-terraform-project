resource "aws_security_group" "myapp-sg" {
  name = "myapp-sg"
  vpc_id = var.vpc_id

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
  subnet_id = var.subnet_id
  vpc_security_group_ids = [ aws_security_group.myapp-sg.id ]
  key_name = aws_key_pair.ssh-key.key_name
  #associate_public_ip_address = true
  user_data = file("entry-script.sh")

  tags = {
    Name = "${var.env_prefix}-myapp-server"
  }
}