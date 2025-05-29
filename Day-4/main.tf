provider "aws" {
  region = "us-east-1"
}
resource "aws_instance" "chandhu" {
    instance_type = "t2.micro"
    ami           = "ami-084568db4383264d4" # Example AMI, replace with a valid one for your region
    key_name = "webserverforawsdemo" # Ensure this key pair exists in your AWS account
}

resource "aws_s3_bucket" "remote_backend_state" {
    bucket= "chandhu-bucket-remote-backend-xyz" # Replace with your desired bucket name
}
resource "aws_dynamodb_table" "terraform_locks" {
    name         = "terraform_locks"
    billing_mode = "PAY_PER_REQUEST"
    hash_key     = "LockID"

    attribute {
        name = "LockID"
        type = "S"
    }

    tags = {
        Name = "Terraform Locks Table"
    }
  
}