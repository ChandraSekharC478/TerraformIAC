terraform {
  backend "s3" {
    bucket         = "chandhu-bucket-remote-backend-xyz"
    key            = "chandra/terraform.tfstate"
    region         = "us-east-1"
   dynamodb_table = "terraform_locks"
   
}
}
