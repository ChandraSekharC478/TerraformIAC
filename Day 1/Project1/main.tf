provider "aws" {
  region = "us-east-1"
}
resource "aws_instance" "terraform_instance" {
  ami = "ami-084568db4383264d4" # Replace with a valid AMI ID ami-0e
  instance_type="t2.micro"
  #subnet_id = ""
  key_name = "webserverforawsdemo"
}