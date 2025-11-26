provider "aws" {
  region = var.region
  
  default_tags {
    tags = {
      Project     = "SADAD-Resilient-Network"
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}

# Data sources for AZs
data "aws_availability_zones" "available" {
  state = "available"
}

# VPC Module - Multi-AZ for Resilience
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"

  name = "${var.cluster_name}-vpc"
  cidr = var.vpc_cidr

  azs             = slice(data.aws_availability_zones.available.names, 0, 3)
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = false # False for High Availability (one per AZ)
  one_nat_gateway_per_az = true

  enable_dns_hostnames = true
  enable_dns_support   = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }
}

# EKS Cluster
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.16.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.27"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  cluster_endpoint_public_access = true

  # EKS Managed Node Group
  eks_managed_node_groups = {
    general = {
      min_size     = 3
      max_size     = 6
      desired_size = 3

      instance_types = ["t3.medium"]
      capacity_type  = "ON_DEMAND"
      
      # Spread across AZs is handled by EKS using the subnets provided
    }
  }
}
