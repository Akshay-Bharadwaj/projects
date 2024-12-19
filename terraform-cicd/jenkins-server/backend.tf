terraform {
  backend "s3" {
    bucket = "tf-cicd-akshay-s3"
    key    = "./terraform.tfstate"
    region = "us-east-1"
  }
}
