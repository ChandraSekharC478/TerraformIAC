provider "aws" {
  region = "us-east-1"
}
variable "cidr_block" {
  description = "This is the cider block for the VPC"
  default     = "10.0.0.0/16"
}
resource "aws_vpc" "myvpc" {
  cidr_block = var.cidr_block
}

resource "aws_subnet" "mysubnet" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "MySubnet"
  }

}
resource "aws_internet_gateway" "myigw" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    Name = "MyInternetGateway"
  }

}
resource "aws_route_table" "myroute" {
  vpc_id = aws_vpc.myvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myigw.id
  }

}
resource "aws_route_table_association" "rta1" {
  subnet_id      = aws_subnet.mysubnet.id
  route_table_id = aws_route_table.myroute.id

}
resource "aws_security_group" "mysecgroup" {
  vpc_id      = aws_vpc.myvpc.id
  name        = "MySecurityGroup"
  description = "Allow SSH and HTTP traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

#   egress = {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1" # -1 means all protocols
#     cidr_blocks = ["0.0.0.0/0"]
#   }

}
output "public_ip" {
  value = aws_instance.terraformProviders.public_ip
}

resource "aws_instance" "terraformProviders" {
  ami                         = "ami-084568db4383264d4"
  instance_type               = "t2.micro"
  key_name                    = "webserverforawsdemo"
  subnet_id                   = aws_subnet.mysubnet.id
  vpc_security_group_ids      = [aws_security_group.mysecgroup.id]
  associate_public_ip_address = true

  tags = {
    Name = "TerraformInstance"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    host        = self.public_ip
    private_key = file("webserverforawsdemo.pem")
  }

  provisioner "file" {
    source      = "app.py"
    destination = "/home/ubuntu/app.py"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y",
      "sudo apt-get install -y python3-pip",
      "pip3 install flask",
      "sudo nohup python3 /home/ubuntu/app.py"
    ]
  }
}
