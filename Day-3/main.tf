provider "aws" {
  region = "us-east-1"
}
module "ec2_instance" {
    source="./modules/Ec2_instance" # path to the module
    ami_value = "ami-084568db4383264d4" # Example AMI ID, replace with your own
    instance_type_value = "t2.micro" # Example instance type, replace with your own
    key_name_value = "webserverforawsdemo" # Example key pair name, replace with your own
}