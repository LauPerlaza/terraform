terraform {
  backend "s3" {
    bucket = "web-ducks-server-develop"
    key = "web-ducks-server-develop"
    region = "us-east-1"
    dynamodb_table = "dynamodb-ducks-develop"
    encrypt = true
   }
}