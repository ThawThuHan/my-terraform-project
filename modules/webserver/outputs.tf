output "aws_ami_id" {
  value = data.aws_ami.latest-amazon-linux-image.id
}

output "public_ip" {
  value = aws_instance.myapp.public_ip
}