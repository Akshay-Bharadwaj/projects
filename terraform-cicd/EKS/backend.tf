terraform {
  backend "s3" {
    region = "us-east-1"
    bucket = "tf-cicd-akshay-s3"
    key    = "./terraform.tfstate"
  }
}