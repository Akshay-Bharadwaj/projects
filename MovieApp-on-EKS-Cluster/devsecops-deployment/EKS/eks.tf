
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.15.1"

  cluster_name                   = local.name
  cluster_endpoint_public_access = true

//add cluster addons like, coredns (serve as cluster dns and expose a static IP i.e. ClusterIP), kube-proxy (runs nodes and routes traffic in them) and cni (assign private IP addresses and create network interfaces for Pods and services in EKS cluster)
  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets

  tags = local.tags
}
