module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.15" # Latest 2026 release

  cluster_name    = local.cluster_name
  cluster_version = "1.33"

  # Networking
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # Access Management (The modern API-based way)
  authentication_mode                         = "API_AND_CONFIG_MAP"
  enable_cluster_creator_admin_permissions    = true

  # Managed Node Groups
  eks_managed_node_groups = {
    standard = {
      # AL2023 is mandatory for EKS 1.33+
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["t3.large"]

      min_size     = 2
      max_size     = 5
      desired_size = 2
    }
  }

  # Add-ons (Core Kubernetes functionality)
  cluster_addons = {
    coredns    = {}
    kube-proxy = {}
    vpc-cni    = {
      before_compute = true
    }
    # Replaces the need for complex OIDC/IRSA setups
    eks-pod-identity-agent = {}
  }

  tags = local.common_tags
}