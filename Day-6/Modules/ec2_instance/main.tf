provider "aws" {
    region = "us-east-1"
  
}
variable "ami" {
  description = "this is the AMI ID for the EC2 instance"
  type= string
}
variable "instance_type" {
  description = "this is the instance type for the EC2 instance"
  type = string
}
variable "key_name" {
  description = "this is the key name for the EC2 instance"
  type = string
  
}
 resource "aws_instance" "workspaces" {
    ami=var.ami
    instance_type = var.instance_type
    key_name = var.key_name
    tags = {
        Name = "prod instance"
    }
   
 }