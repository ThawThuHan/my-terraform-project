#!/bin/bash
sudo yum update -y && sudo yum install -y docker
sudo systemctl start docker
sudo usermod -aG docker ec2-user
newgrp docker
docker run -d -p 8080:80 nginx 
