//vpc
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "tf-cicd-akshay-vpc"
  cidr = var.cidr_block

  azs = ["us-east-1a", "us-east-1b", "us-east-1c"]

  tags = {
    Name = "tf-cicd-akshay-vpc"
  }

  enable_dns_hostnames = true
  map_public_ip_on_launch = true

  public_subnet_tags = {
    Name = "tf-cicd-akshay-subnet1"
  }
}

//subnet
resource "aws_subnet" "tf-cicd-akshay-subnet1" {
  tags = {
    Name = "tf-cicd-akshay-subnet1"
  }

  vpc_id     = module.vpc.vpc_id
  cidr_block = "10.0.2.0/24"

  map_public_ip_on_launch = true
}

//security group
resource "aws_security_group" "tf-cicd-akshay-sg1" {
  description = "security group for resources"
  vpc_id = module.vpc.vpc_id
  tags = {
    Name = "tf-cicd-akshay-sg1"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ingress-rule1" {
  security_group_id = aws_security_group.tf-cicd-akshay-sg1.id
  description       = "HTTP from VPC"
  cidr_ipv4         = var.cidr_blocks
  from_port         = 8080
  to_port           = 8080
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "ingress-rule2" {
  security_group_id = aws_security_group.tf-cicd-akshay-sg1.id
  description       = "SSH from VPC"
  cidr_ipv4         = var.cidr_blocks
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "egress-rule" {
  security_group_id = aws_security_group.tf-cicd-akshay-sg1.id
  cidr_ipv4         = var.cidr_blocks
  from_port         = -1
  to_port           = -1
  ip_protocol       = "-1"
}

//ec2

module "ec2_instance"  {

  source = "terraform-aws-modules/ec2-instance/aws"

  name = "tf-cicd-akshay-instance"

  ami = var.ami
  instance_type = var.instance_type
  key_name = "jenkins-demo"
  monitoring = true

  vpc_security_group_ids = [aws_security_group.tf-cicd-akshay-sg1.id]
  subnet_id = aws_subnet.tf-cicd-akshay-subnet1.id
  availability_zone = module.vpc.azs[1]
  associate_public_ip_address = true

  user_data = file("jenkins-install.sh")

  tags = {
    Name = "tf-cicd-akshay-instance"
    Terraform   = "true"
    Environment = "dev"
  }
}