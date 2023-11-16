terraform {
  backend "s3" {
    bucket = "terraform-test"
    key = "back-terraform-test"
    region = "us-east-1"
    dynamodb_table = "dynamodb-terraform-test"
    encrypt = true
   }
}