provider "aws" {
  region = "us-east-1"
}
variable "ami" {
  description = "this is the AMI ID for the EC2 instance"
  type        = string
  
}
variable "instance_type" {
  description = "this is the instance type for the EC2 instance"
  type        = map(string)
  default = {
    "dev" = "t2.micro"
    "UAT"= "t2.small"
    "prod" = "t2.medium"
  }
  
}
variable "key_name" {
  description = "this is the key name for the EC2 instance"
  type        = string
  
}
module "ec2_instance" {
  source        = "./Modules/ec2_instance"
  ami           = var.ami
  instance_type = lookup(var.instance_type, terraform.workspace, "t2.micro") # Default to t2.micro if not found
  key_name      = var.key_name
  
}