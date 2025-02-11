#provider configurations using locals module to avoid duplication

locals {
  region = "ap-west-1"
  name   = "movieapp-cluster"
  vpc_cidr = "10.123.0.0/16"
  azs      = ["ap-west-1a", "ap-west-1b"]
  public_subnets  = ["10.123.1.0/24", "10.123.2.0/24"]
  private_subnets = ["10.123.3.0/24", "10.123.4.0/24"]
  intra_subnets   = ["10.123.5.0/24", "10.123.6.0/24"]
  tags = {
    Example = local.name
  }
}

provider "aws" {
  region = "ap-west-1"
}
