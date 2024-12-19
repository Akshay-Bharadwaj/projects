//vpc
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "tf-cicd-akshay-vpc"
  cidr = var.cidr_block

  azs = var.azs

  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_dns_hostnames = true
  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    "kubernetes.io/cluster/my-eks-cluster" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/my-eks-cluster" = "shared"
    "kubernetes.io/role/elb" = "true"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/my-eks-cluster" = "shared"
    "kubernetes.io/role/internal-elb" = "true"
  }
}

//eks cluster
module "eks" {
  source  = "terraform-aws-modules/eks/aws"

  cluster_name    = "tf-cicd-akshay-eks"
  cluster_version = "1.24"

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets

  cluster_endpoint_public_access = true

  eks_managed_node_groups = {
    nodes = {
      instance_types = ["t2.micro"]

      min_size     = 1
      max_size     = 3
      desired_size = 2
    }
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}