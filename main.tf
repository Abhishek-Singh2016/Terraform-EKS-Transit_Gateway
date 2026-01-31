module "vpc_module" {
  source = "./modules/vpc"
 
}

module "eks_module" {
  source = "./modules/EKS"
 
}





module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0" # Ensure you use v21+ for modern Access Entry support

  cluster_name    = local.cluster_name
  cluster_version = "1.33" # Latest January 2026 stable release

  # Network configuration
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # Access Management (The modern replacement for aws-auth)
  # This allows AWS IAM users/roles to be mapped to K8s groups via Terraform
  authentication_mode                         = "API_AND_CONFIG_MAP"
  enable_cluster_creator_admin_permissions    = true

  # Encryption at Rest for Secrets
  cluster_encryption_config = {
    resources = ["secrets"]
  }

  # Managed Node Groups (Workers)
  eks_managed_node_groups = {
    # Standard workload nodes
    standard = {
      ami_type       = "AL2023_x86_64_STANDARD" # Optimized Amazon Linux 2023
      instance_types = ["t3.large"]

      min_size     = 2
      max_size     = 10
      desired_size = 2

      # Enable IMDSv2 for security compliance
      metadata_options = {
        http_endpoint               = "enabled"
        http_tokens                 = "required"
        http_put_response_hop_limit = 2
      }

      labels = {
        Role = "worker"
      }
    }
  }

  # Essential Cluster Add-ons
  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      before_compute = true # Setup networking before nodes join
      most_recent    = true
    }
    # Mandatory for Pod IAM permissions in 2026
    eks-pod-identity-agent = {
      most_recent = true
    }
  }

  tags = local.common_tags
}