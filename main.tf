terraform {
  backend "s3" {
    bucket = "ec2-tfstate-zak"
    key    = "ec2/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
  }
}



provider "aws" {
    region = "us-east-1"
}

#create instance 
resource "aws_instance" "terraform-ec2" {
  ami           = "ami-052efd3df9dad4825"
  instance_type = "t2.micro"
  key_name = "ec2keypair"
  security_groups = [aws_security_group.t-allow_tls.name]

  tags = {
    Name = "Terraform-ec2"
  }
}

#create security group and allow port 80 and 22
resource "aws_security_group" "t-allow_tls" {
  name        = "allow-80-22"
  description = "Allow TLS inbound traffic"
  #vpc_id      = aws_vpc.main.id
  vpc_id = "vpc-0ec36ce1caa5fe626"


 ingress {
    description      = "http"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }


 ingress {
    description      = "ssh"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

   egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  

  tags = {
    Name = "allow_tls"
  }
}

#security group attach to ec2
# resource "aws_network_interface_sg_attachment" "nt-it-att" {
#   security_group_id = aws_security_group.t-allow_tls.id
#   network_interface_id = aws_instance.terraform-ec2.primary_network_interface_id
# }

